Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D0359E32A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355350AbiHWMSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354348AbiHWMP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379C7E9939;
        Tue, 23 Aug 2022 02:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64B2614D1;
        Tue, 23 Aug 2022 09:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F19C433D6;
        Tue, 23 Aug 2022 09:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247585;
        bh=G4vUUcbTC3wk22PLjx9tPddjoJp2bdeLQwk8tm6Cz14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqI7uecwimR1wRrSo7WgoSHjzMvzuM5XarbYHTtxH6SeOWiR7ddxXft8H3pVTUzRt
         LdIU9/FJCNYtwW5FTRdIzEHeOz2pPBwLuSbIYe2P38DKuR4Tu3MmOOU70blvY7HIhp
         CkxTbw5GSjs9v199vv+E+cN2DCy7OmhMtJCOIR7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 082/158] net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry
Date:   Tue, 23 Aug 2022 10:26:54 +0200
Message-Id: <20220823080049.363280513@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Ramadoss <arun.ramadoss@microchip.com>

commit 36c0d935015766bf20d621c18313f17691bda5e3 upstream.

In the ksz9477_fdb_dump function it reads the ALU control register and
exit from the timeout loop if there is valid entry or search is
complete. After exiting the loop, it reads the alu entry and report to
the user space irrespective of entry is valid. It works till the valid
entry. If the loop exited when search is complete, it reads the alu
table. The table returns all ones and it is reported to user space. So
bridge fdb show gives ff:ff:ff:ff:ff:ff as last entry for every port.
To fix it, after exiting the loop the entry is reported only if it is
valid one.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220816105516.18350-1-arun.ramadoss@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz9477.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -762,6 +762,9 @@ static int ksz9477_port_fdb_dump(struct
 			goto exit;
 		}
 
+		if (!(ksz_data & ALU_VALID))
+			continue;
+
 		/* read ALU table */
 		ksz9477_read_table(dev, alu_table);
 


