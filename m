Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01F74F346D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245273AbiDEIyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241031AbiDEIco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D406B6E4A;
        Tue,  5 Apr 2022 01:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09AB260FFC;
        Tue,  5 Apr 2022 08:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C282C385A2;
        Tue,  5 Apr 2022 08:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147168;
        bh=qJwoahL5TaaVMJ3/kjEW4fYmVnK41gYPiiwNhITEXjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8bIPT3FEeNXNEscrJNEiHOeVRNw+TmL0NW4/MU80i5JVgfqVFmGI9LIRTG6zAfKp
         a7QyVR2WNCWY2Z1RsjK/gtxw95lcqbjjQQGjMtTXkMmH4DvmNkb2wM5z10O2vzUws8
         CQRVzhQ7zH/m3USnmlEjV8tvjA3Fuz1olwSKjxj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.17 1026/1126] rtc: gamecube: Fix refcount leak in gamecube_rtc_read_offset_from_sram
Date:   Tue,  5 Apr 2022 09:29:33 +0200
Message-Id: <20220405070437.596566652@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 4b2dc39ca024990abe36ad5d145c4fe0c06afd34 upstream.

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Fixes: 86559400b3ef ("rtc: gamecube: Add a RTC driver for the GameCube, Wii and Wii U")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220309092225.6930-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-gamecube.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/rtc-gamecube.c
+++ b/drivers/rtc/rtc-gamecube.c
@@ -235,6 +235,7 @@ static int gamecube_rtc_read_offset_from
 	}
 
 	ret = of_address_to_resource(np, 0, &res);
+	of_node_put(np);
 	if (ret) {
 		pr_err("no io memory range found\n");
 		return -1;


