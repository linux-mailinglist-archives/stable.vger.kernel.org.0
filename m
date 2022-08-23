Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCADC59E005
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358774AbiHWLyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358674AbiHWLwl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:52:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9ADD5717;
        Tue, 23 Aug 2022 02:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC423B81C50;
        Tue, 23 Aug 2022 09:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37911C433D7;
        Tue, 23 Aug 2022 09:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247170;
        bh=ndWiiY4NeHQG8/CTphvxdicS3nDa17lUBfCluKN6RgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywI+qmKp2uHq2OlYYNc0W+Ww/e83mNIcfJXs/9xQNH+rGREWutL9uE7o8jdQkAx2T
         ddlTB0hWnVKsjpzlJwPyMEAC2Y/O7DdyOquMhA50YrWcUzMlnCBrCdtduwvcWLQtyP
         RoQSUa9NKPekgDyfcTNiE5mgA/BOYrlhF8R9+KdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 341/389] net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry
Date:   Tue, 23 Aug 2022 10:26:59 +0200
Message-Id: <20220823080129.781184318@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -766,6 +766,9 @@ static int ksz9477_port_fdb_dump(struct
 			goto exit;
 		}
 
+		if (!(ksz_data & ALU_VALID))
+			continue;
+
 		/* read ALU table */
 		ksz9477_read_table(dev, alu_table);
 


