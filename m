Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2B38F04D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhEXQCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235739AbhEXQBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AFB56108E;
        Mon, 24 May 2021 15:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871200;
        bh=z+x9sfBndTpSV/Z25LvBDWoiyAV8PcfNG3sB9v3VDrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cgIG0+82zQvDe04IopPNS4C3JApTRTZUHsn6z6U2ViUzYv/PgoPjBazGrc4pCoQn
         TBDOascHDOn8PfFTyyL+zte9pw5KVeCoGTTTpvAn2rZws39qxipLAmAE4zxhsxY4Iq
         94UnC0p6wrjCKTMH0htd1h+Pi2P2TmK37s90VW3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 119/127] vt_ioctl: Revert VT_RESIZEX parameter handling removal
Date:   Mon, 24 May 2021 17:27:16 +0200
Message-Id: <20210524152338.889687421@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit a90c275eb144c1b755f04769e1f29d832d6daeaf upstream.

Revert the removal of code handling extra VT_RESIZEX ioctl's parameters
beyond those that VT_RESIZE supports, fixing a functional regression
causing `svgatextmode' not to resize the VT anymore.

As a consequence of the reverted change when the video adapter is
reprogrammed from the original say 80x25 text mode using a 9x16
character cell (720x400 pixel resolution) to say 80x37 text mode and the
same character cell (720x592 pixel resolution), the VT geometry does not
get updated and only upper two thirds of the screen are used for the VT,
and the lower part remains blank.  The proportions change according to
text mode geometries chosen.

Revert the change verbatim then, bringing back previous VT resizing.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 988d0763361b ("vt_ioctl: make VT_RESIZEX behave like VT_RESIZE")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |   57 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 10 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -671,21 +671,58 @@ static int vt_resizex(struct vc_data *vc
 	if (copy_from_user(&v, cs, sizeof(struct vt_consize)))
 		return -EFAULT;
 
-	if (v.v_vlin)
-		pr_info_once("\"struct vt_consize\"->v_vlin is ignored. Please report if you need this.\n");
-	if (v.v_clin)
-		pr_info_once("\"struct vt_consize\"->v_clin is ignored. Please report if you need this.\n");
+	/* FIXME: Should check the copies properly */
+	if (!v.v_vlin)
+		v.v_vlin = vc->vc_scan_lines;
+
+	if (v.v_clin) {
+		int rows = v.v_vlin / v.v_clin;
+		if (v.v_rows != rows) {
+			if (v.v_rows) /* Parameters don't add up */
+				return -EINVAL;
+			v.v_rows = rows;
+		}
+	}
+
+	if (v.v_vcol && v.v_ccol) {
+		int cols = v.v_vcol / v.v_ccol;
+		if (v.v_cols != cols) {
+			if (v.v_cols)
+				return -EINVAL;
+			v.v_cols = cols;
+		}
+	}
+
+	if (v.v_clin > 32)
+		return -EINVAL;
 
-	console_lock();
 	for (i = 0; i < MAX_NR_CONSOLES; i++) {
-		vc = vc_cons[i].d;
+		struct vc_data *vcp;
+
+		if (!vc_cons[i].d)
+			continue;
+		console_lock();
+		vcp = vc_cons[i].d;
+		if (vcp) {
+			int ret;
+			int save_scan_lines = vcp->vc_scan_lines;
+			int save_font_height = vcp->vc_font.height;
 
-		if (vc) {
-			vc->vc_resize_user = 1;
-			vc_resize(vc, v.v_cols, v.v_rows);
+			if (v.v_vlin)
+				vcp->vc_scan_lines = v.v_vlin;
+			if (v.v_clin)
+				vcp->vc_font.height = v.v_clin;
+			vcp->vc_resize_user = 1;
+			ret = vc_resize(vcp, v.v_cols, v.v_rows);
+			if (ret) {
+				vcp->vc_scan_lines = save_scan_lines;
+				vcp->vc_font.height = save_font_height;
+				console_unlock();
+				return ret;
+			}
 		}
+		console_unlock();
 	}
-	console_unlock();
 
 	return 0;
 }


