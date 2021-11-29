Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6E046255F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhK2WiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhK2Whm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:37:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9777FC12BCED;
        Mon, 29 Nov 2021 10:34:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E45B8CE1626;
        Mon, 29 Nov 2021 18:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88514C53FAD;
        Mon, 29 Nov 2021 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210896;
        bh=OsYSipFABkzsjTcWvxlaBSAjDBL/mL7Yex6zNIjFwWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQyK+1LxV9DThETXUl0d4qp1m52hrMDBfuLO0YkTFAnhyp5/ATNAnzeoeft7o2NNJ
         GDM0kPex5/mvfyJ5fCoh4eDY71iNx1Bf0eG9PuRj78bwhhNodugrhuQi+ahI323BW7
         +N57WwavvFyYhfF9IWyLrFhkTOFBa1Z18vNOQfyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 5.15 033/179] staging: r8188eu: use GFP_ATOMIC under spinlock
Date:   Mon, 29 Nov 2021 19:17:07 +0100
Message-Id: <20211129181720.037624250@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Straube <straube.linux@gmail.com>

commit 4a293eaf92a510ff688dc7b3f0815221f99c9d1b upstream.

In function rtw_report_sec_ie() kzalloc() is called under a spinlock,
so the allocation have to be atomic.

Call tree:

-> rtw_select_and_join_from_scanned_queue() <- takes a spinlock
   -> rtw_joinbss_cmd()
      -> rtw_restruct_sec_ie()
         -> rtw_report_sec_ie()

Fixes: 2b42bd58b321 ("staging: r8188eu: introduce new os_dep dir for RTL8188eu driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Link: https://lore.kernel.org/r/20211108105537.31655-1-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/os_dep/mlme_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/r8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/r8188eu/os_dep/mlme_linux.c
@@ -114,7 +114,7 @@ void rtw_report_sec_ie(struct adapter *a
 
 	buff = NULL;
 	if (authmode == _WPA_IE_ID_) {
-		buff = kzalloc(IW_CUSTOM_MAX, GFP_KERNEL);
+		buff = kzalloc(IW_CUSTOM_MAX, GFP_ATOMIC);
 		if (!buff)
 			return;
 		p = buff;


