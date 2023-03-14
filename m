Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BD26B9DB6
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjCNR7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjCNR67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:58:59 -0400
Received: from fallback24.i.mail.ru (fallback24.i.mail.ru [79.137.243.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581066152C;
        Tue, 14 Mar 2023 10:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=gKu7jZ3XQlixXTcEpNbSkeHUeKw74OsjUaio63WgeFs=;
        t=1678816737;x=1678906737; 
        b=0GXV322mVD+c1ZQRoukuymFH/HFPSvKlwJQEamox3SavZSI+IkcAYXKnNTbW4s9uaADC81WBoV4+/Ge6tXmZYd2/auW0zzPW6Q2Ei0QEsCKe/WAASjsE+CjBvofsVOEIhCf3ZBfIiy1x57beqB7Wiv0lJR3KLV9WB0rJejn8BVa1OT9kWg6kYDxps+7dYvLxyB3y/LJ3cAZNUyJwI3IgnwLzqZA55oopenyM05/+STjWmczCmo2yKZDFOZTPLKIvbvhoEK7gz5lufWoOP8vl2J880DodPydT8U+p3eq7v8IHaH7b4p54I8wd1RChNuBszkv3LbA6l1sLZiQvYbGVMQ==;
Received: from [10.12.4.22] (port=50702 helo=smtp41.i.mail.ru)
        by fallback24.i.mail.ru with esmtp (envelope-from <listdansp@mail.ru>)
        id 1pc82N-005rTW-CZ; Tue, 14 Mar 2023 20:02:11 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=gKu7jZ3XQlixXTcEpNbSkeHUeKw74OsjUaio63WgeFs=;
        t=1678813331;x=1678903331; 
        b=vB9QPZCAz8NyZxMKmUGuwTMHHomHIqQ/Ot7WeR8KT4JYQeW88bAM9HNRS7opXcrolwCKlrnkTeRsUz6Lr9DLzY6v4LHMVBQHJiQnHfw9Mzm+V/zqLeusOp2tIZXCsh77bztCWBVZC/JhpoO7GQiAWqqICuwwAT6QW9myoPe9+DgVj79WXmscyHyFtJQsQuJ+1pTBEMimt/9QS+/vQMUB+Hc5u6DiPAV87PC7EbZUXtJhic/Mf/OnZsqV+ZEQ/z9dKkMfzg945KtBxwS03UrBXvQFWHdn7CcPjQqKahn3iwq166LZcuIADH0b3cR3PmwQOBhaKg49sbb70tl8dhd2rQ==;
Received: by smtp41.i.mail.ru with esmtpa (envelope-from <listdansp@mail.ru>)
        id 1pc82H-005Cqp-HK; Tue, 14 Mar 2023 20:02:05 +0300
From:   Danila Chernetsov <listdansp@mail.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Danila Chernetsov <listdansp@mail.ru>, Bin Liu <b-liu@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH 5.10 1/1] usb: musb: core: drop redundant checks
Date:   Tue, 14 Mar 2023 17:01:13 +0000
Message-Id: <20230314170113.11968-2-listdansp@mail.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230314170113.11968-1-listdansp@mail.ru>
References: <20230314170113.11968-1-listdansp@mail.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailru-Src: smtp
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9BCEC41593EBD8357A3BFCFA0FC8EDD65B542913A4AA2B57D182A05F538085040C1CC0EA9FC0D4F21895E51DE8734835D78DCE073CD834F2152C2C46CC97259AD
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7AC4684DF4EC4B256EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006377CBEE85FF77996C68638F802B75D45FF36EB9D2243A4F8B5A6FCA7DBDB1FC311F39EFFDF887939037866D6147AF826D8220A9BDDD319B52DDD202B59F1D020046F9789CCF6C18C3F8528715B7D10C86878DA827A17800CE767883B903EA3BAEA9FA2833FD35BB23D9E625A9149C048EE41BF15D38FB6CB3AE5D25F19253116ADD2E47CDBA5A96583BD4B6F7A4D31EC0BC014FD901B82EE079FA2833FD35BB23D27C277FBC8AE2E8B7AB48659A3697231A471835C12D1D977C4224003CC836476EB9C4185024447017B076A6E789B0E975F5C1EE8F4F765FC372E3A6649EBCBD43AA81AA40904B5D9CF19DD082D7633A078D18283394535A93AA81AA40904B5D98AA50765F79006379DFC81A7F559A640D81D268191BDAD3D3666184CF4C3C14F3FC91FA280E0CE3D1A620F70A64A45A98AA50765F7900637F1CEADB5F7626D0D6D1867E19FE1407959CC434672EE6371089D37D7C0E48F6C8AA50765F7900637569CCF021E1EA749EFF80C71ABB335746BA297DBC24807EABDAD6C7F3747799A
X-C1DE0DAB: 0D63561A33F958A57C61C1AE9CDDA8C156EED8FE08986FA337CAC58D880C083A4EAF44D9B582CE87C8A4C02DF684249C2E763F503762DF50F2237FE565727C05
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D34F6110710A6CC527FAB0DC727A3996EEDB3D868EAF6BDE309BB914C17868EF3252DF86812989B262F1D7E09C32AA3244C5166931504D7C9894F9D5AB40021D30455E75C8D0ED9F6EEAD832FF50B3043B1
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojOXwBDQf4j7NFXm8FOx/Bwg==
X-Mailru-Sender: 4CE1109FD677D2770147F6A9E21DCA7B69F168FADF6A6FA7985B123C060666DBF5494DF53083D48C7E3C9C7AF06D9E7B78274A4A9E9E44FD3C3897ABF9FF211DE8284E426C7B2D9A5FEEDEB644C299C0ED14614B50AE0675
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B4BD2EB812D5A6E5F7D3C1BE093F4DBF3E2B993039976DEF5E049FFFDB7839CE9E316722B9905B3D225B6D9B08B0E37B2E87B4BC62FD7507EAF00E6702C10BABA2
X-7FA49CB5: 0D63561A33F958A58C0C7F0D227C16D6F38EB38CC73D6A172D801D76CE9C0F45CACD7DF95DA8FC8BD5E8D9A59859A8B6A096F61ED9298604
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5xhPKz0ZEsZ5k6NOOPWz5QAiZSCXKGQRq3/7KxbCLSB2ESzQkaOXqCBFZPLWFrEGlV1shfWe2EVcxl5toh0c/aCGOghz/frdRhzMe95NxDFdAc2jUOxWGfzrxixSJ7arfw==
X-Mailru-MI: C000000000000800
X-Mras: Ok
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit b0ec7e55fce65f125bd1d7f02e2dc4de62abee34 upstream. 

In musb_{save|restore}_context() the expression '&musb->endpoints[i]' just
cannot be NULL, so the checks have no sense at all -- after dropping them,
the local variables 'hw_ep' are no longer necessary, so drop them as well.

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/3f8f60d9-f1b5-6b2c-1222-39b156151a22@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
---
 drivers/usb/musb/musb_core.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 4c8f0112481f..605f5cc0f18b 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2673,13 +2673,7 @@ static void musb_save_context(struct musb *musb)
 	musb->context.devctl = musb_readb(musb_base, MUSB_DEVCTL);
 
 	for (i = 0; i < musb->config->num_eps; ++i) {
-		struct musb_hw_ep	*hw_ep;
-
-		hw_ep = &musb->endpoints[i];
-		if (!hw_ep)
-			continue;
-
-		epio = hw_ep->regs;
+		epio = musb->endpoints[i].regs;
 		if (!epio)
 			continue;
 
@@ -2754,13 +2748,7 @@ static void musb_restore_context(struct musb *musb)
 		musb_writeb(musb_base, MUSB_DEVCTL, musb->context.devctl);
 
 	for (i = 0; i < musb->config->num_eps; ++i) {
-		struct musb_hw_ep	*hw_ep;
-
-		hw_ep = &musb->endpoints[i];
-		if (!hw_ep)
-			continue;
-
-		epio = hw_ep->regs;
+		epio = musb->endpoints[i].regs;
 		if (!epio)
 			continue;
 
-- 
2.25.1

