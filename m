Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A435321756
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhBVMqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhBVMng (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D46EF64F3C;
        Mon, 22 Feb 2021 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997614;
        bh=QL+eJF+nLlcjNio5bbPmh3QrMcqq8ZzC2X8yadV1Oj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YbIaDZqXpm2ptHW8lXEYE+bzRkYtfWmk5hkbqvku22mN+tkMYZZf6BIaSgy7xSM9
         CQ+6nmwbKrQ5WTG3hD++QqIrQSx9elv3GGi+ZCLuPBK1HryboS0CQmxIpm/0PhYEKo
         Ayw/axuH4nNu1hjpKo3t3SxaAQR4659OGG1w9B2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 32/35] xen-scsiback: dont "handle" error by BUG()
Date:   Mon, 22 Feb 2021 13:36:28 +0100
Message-Id: <20210222121022.276891766@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 7c77474b2d22176d2bfb592ec74e0f2cb71352c9 upstream.

In particular -ENOMEM may come back here, from set_foreign_p2m_mapping().
Don't make problems worse, the more that handling elsewhere (together
with map's status fields now indicating whether a mapping wasn't even
attempted, and hence has to be considered failed) doesn't require this
odd way of dealing with errors.

This is part of XSA-362.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-scsiback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -415,12 +415,12 @@ static int scsiback_gnttab_data_map_batc
 		return 0;
 
 	err = gnttab_map_refs(map, NULL, pg, cnt);
-	BUG_ON(err);
 	for (i = 0; i < cnt; i++) {
 		if (unlikely(map[i].status != GNTST_okay)) {
 			pr_err("invalid buffer -- could not remap it\n");
 			map[i].handle = SCSIBACK_INVALID_HANDLE;
-			err = -ENOMEM;
+			if (!err)
+				err = -ENOMEM;
 		} else {
 			get_page(pg[i]);
 		}


