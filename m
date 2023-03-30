Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9ED6D0FBF
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 22:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjC3ULk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 16:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjC3ULk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 16:11:40 -0400
Received: from smtp41.i.mail.ru (smtp41.i.mail.ru [95.163.41.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AE59EF3;
        Thu, 30 Mar 2023 13:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=EIH2QdlPOds6u2++C3qJ9JhamJyqZEPglXfnOZSJdD8=;
        t=1680207099;x=1680297099; 
        b=nzLsUfW5+86CseVFQSSp07g7Cyb40krt8h2CYCWn4vCrY32ADznHEnaZw8blt1iN2BsQy5PWIA16lKau/vruUSnYzxQB8d10bVX+iI95kcoT1QNmYtrLT+SC7GLZ9CyY7cxgjuqXALkhWdAWB7Uq/jc5lYttdqcpwu5DsV6sK5wthNeABQmRHIjiujujLo6gMJIlEmESsatQwO3fkmMLbk056NfVLL+crKk7m0dxoMNw4hr9Yt6N9aC8h75CpgIq5PeRNWJ5MTrPE9+eu9BC3mhJD9beRKTjdZFlmD4Q85iu/9htcT8iBds3L1KaM03VtrJ2EzHG1fsHjMG9OLOWUQ==;
Received: by smtp41.i.mail.ru with esmtpa (envelope-from <listdansp@mail.ru>)
        id 1phycS-007xQb-Vd; Thu, 30 Mar 2023 23:11:37 +0300
From:   Danila Chernetsov <listdansp@mail.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Danila Chernetsov <listdansp@mail.ru>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] staging: rtl8192u: Add null check in rtl8192_usb_initendpoints
Date:   Thu, 30 Mar 2023 20:11:07 +0000
Message-Id: <20230330201107.17647-2-listdansp@mail.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230330201107.17647-1-listdansp@mail.ru>
References: <20230330201107.17647-1-listdansp@mail.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp41.i.mail.ru; auth=pass smtp.auth=listdansp@mail.ru smtp.mailfrom=listdansp@mail.ru
X-Mailru-Src: smtp
X-7564579A: B8F34718100C35BD
X-77F55803: 4F1203BC0FB41BD9381BDEF7E890522320C180A75E467735B577A508162297EF182A05F538085040273A521DCF28E9013A6CFA342E5363067125BA82C907DD197465CDCA89556769
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7E2331B2371EFE129EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F790063732727FD5A4355FD18638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D86D69A6A09FF8BD4EB90AB18C8DEC6A3B6F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE786A06C54C89EF27D9FA2833FD35BB23D9E625A9149C048EEC65AC60A1F0286FEF6B57BC7E64490618DEB871D839B7333395957E7521B51C2DFABB839C843B9C08941B15DA834481F8AA50765F7900637602B56D4CB39C6A8389733CBF5DBD5E9B5C8C57E37DE458BD9DD9810294C998ED8FC6C240DEA76428AA50765F7900637EDAD75E181AE3ED6D81D268191BDAD3DBD4B6F7A4D31EC0BEA7A3FFF5B025636D81D268191BDAD3D78DA827A17800CE74CC2140C3C9C7F95EC76A7562686271ED91E3A1F190DE8FD2E808ACE2090B5E14AD6D5ED66289B5259CC434672EE63711DD303D21008E298D5E8D9A59859A8B6B372FE9A2E580EFC725E5C173C3A84C322275D389A24191C35872C767BF85DA2F004C90652538430E4A6367B16DE6309
X-C1DE0DAB: 0D63561A33F958A5D5A42AB246F214E111877D0E07F277A99B9A4F9FFC1503B2F87CCE6106E1FC07E67D4AC08A07B9B0DB8A315C1FF4794DC79554A2A72441328621D336A7BC284946AD531847A6065AED8438A78DFE0A9EBDAD6C7F3747799A
X-C8649E89: 1C3962B70DF3F0ADE00A9FD3E00BEEDF77DD89D51EBB7742D3581295AF09D3DF87807E0823442EA2ED31085941D9CD0AF7F820E7B07EA4CF528894E26D16B659DF6D4F38B08EDF3329E2EBA2257983B2A913DAC57452B0DF1F5011C79ABBA8E762C9293813A964D6609E80B1DF7DADDFE433E735305914D032947E98E9153962
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojoVQ5iBoMj9ZhMqCk1yX0rg==
X-Mailru-Sender: F244DC1430FACE54496B7D2C616565FD134E7648211741201D697B3E1A180717839022FC6F811F10CE8DDCF05647143DC77752E0C033A69E3DC0BC7494A416CF0226C39053983FF0B4A721A3011E896F
X-Mras: Ok
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 4d5f81506835f7c1e5c71787bed84984faf05884 upstream.

There is an allocation for priv->rx_urb[16] has no null check,
which may lead to a null pointer dereference.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20201226080258.6576-1-dinghao.liu@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
---
 drivers/staging/rtl8192u/r8192U_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7f90af8a7c7c..e0fec7d172da 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1608,6 +1608,8 @@ static short rtl8192_usb_initendpoints(struct net_device *dev)
 		void *oldaddr, *newaddr;
 
 		priv->rx_urb[16] = usb_alloc_urb(0, GFP_KERNEL);
+		if (!priv->rx_urb[16])
+			return -ENOMEM;
 		priv->oldaddr = kmalloc(16, GFP_KERNEL);
 		if (!priv->oldaddr)
 			return -ENOMEM;
-- 
2.25.1

