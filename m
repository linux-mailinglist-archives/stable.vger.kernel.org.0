Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE18171B71
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733133AbgB0OC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733130AbgB0OC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E020524656;
        Thu, 27 Feb 2020 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812148;
        bh=vf+BHOk1D3Q/VYSnXXbrInsyNf9aOGqq0TC375Y6d74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaXRZhesZNEUpP7jUpvG9oskxo/938hG8IZA9DdMtnofk2BPeBZL+HaMmYOotgYgI
         SrbQzRQUfCJEqtllAgGyWbkhlA5qrW/VxIOXtTaAAh9cLHFZFbcsHlG7IU42VJMNHo
         I14kIBqFXt4JOPnDGy1IDch1UpElBHzc/EcOEONQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 202/237] VT_RESIZEX: get rid of field-by-field copyin
Date:   Thu, 27 Feb 2020 14:36:56 +0100
Message-Id: <20200227132311.129561837@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1b3bce4d6bf839304a90951b4b25a5863533bf2a ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt_ioctl.c | 68 ++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 41 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 7b34b0ddbf0e0..be7990548afef 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -847,58 +847,44 @@ int vt_ioctl(struct tty_struct *tty,
 
 	case VT_RESIZEX:
 	{
-		struct vt_consize __user *vtconsize = up;
-		ushort ll,cc,vlin,clin,vcol,ccol;
+		struct vt_consize v;
 		if (!perm)
 			return -EPERM;
-		if (!access_ok(VERIFY_READ, vtconsize,
-				sizeof(struct vt_consize))) {
-			ret = -EFAULT;
-			break;
-		}
+		if (copy_from_user(&v, up, sizeof(struct vt_consize)))
+			return -EFAULT;
 		/* FIXME: Should check the copies properly */
-		__get_user(ll, &vtconsize->v_rows);
-		__get_user(cc, &vtconsize->v_cols);
-		__get_user(vlin, &vtconsize->v_vlin);
-		__get_user(clin, &vtconsize->v_clin);
-		__get_user(vcol, &vtconsize->v_vcol);
-		__get_user(ccol, &vtconsize->v_ccol);
-		vlin = vlin ? vlin : vc->vc_scan_lines;
-		if (clin) {
-			if (ll) {
-				if (ll != vlin/clin) {
-					/* Parameters don't add up */
-					ret = -EINVAL;
-					break;
-				}
-			} else 
-				ll = vlin/clin;
+		if (!v.v_vlin)
+			v.v_vlin = vc->vc_scan_lines;
+		if (v.v_clin) {
+			int rows = v.v_vlin/v.v_clin;
+			if (v.v_rows != rows) {
+				if (v.v_rows) /* Parameters don't add up */
+					return -EINVAL;
+				v.v_rows = rows;
+			}
 		}
-		if (vcol && ccol) {
-			if (cc) {
-				if (cc != vcol/ccol) {
-					ret = -EINVAL;
-					break;
-				}
-			} else
-				cc = vcol/ccol;
+		if (v.v_vcol && v.v_ccol) {
+			int cols = v.v_vcol/v.v_ccol;
+			if (v.v_cols != cols) {
+				if (v.v_cols)
+					return -EINVAL;
+				v.v_cols = cols;
+			}
 		}
 
-		if (clin > 32) {
-			ret =  -EINVAL;
-			break;
-		}
-		    
+		if (v.v_clin > 32)
+			return -EINVAL;
+
 		for (i = 0; i < MAX_NR_CONSOLES; i++) {
 			if (!vc_cons[i].d)
 				continue;
 			console_lock();
-			if (vlin)
-				vc_cons[i].d->vc_scan_lines = vlin;
-			if (clin)
-				vc_cons[i].d->vc_font.height = clin;
+			if (v.v_vlin)
+				vc_cons[i].d->vc_scan_lines = v.v_vlin;
+			if (v.v_clin)
+				vc_cons[i].d->vc_font.height = v.v_clin;
 			vc_cons[i].d->vc_resize_user = 1;
-			vc_resize(vc_cons[i].d, cc, ll);
+			vc_resize(vc_cons[i].d, v.v_cols, v.v_rows);
 			console_unlock();
 		}
 		break;
-- 
2.20.1



