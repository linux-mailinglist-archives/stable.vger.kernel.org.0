Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507C62F5118
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 18:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbhAMR1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 12:27:25 -0500
Received: from mx.cjr.nz ([51.158.111.142]:31180 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727446AbhAMR1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 12:27:24 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2021 12:27:24 EST
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E37127FD55;
        Wed, 13 Jan 2021 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1610558186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSCNmni3GEWpm4WEf0TUaQXPQtSfjZ/qr/nmhuS4btk=;
        b=N2n5Ml+jDotLVNO/vxGfPA9RGShJL7Pb80jH42j3/WzNvpcIDN/GLktEgTBRHdmMC35n/L
        8tTT/IPZv/NakgzglpAgjGuwd+C3vFnhKFNAHEzQNyjDvfyWZHjBIyEZ3Om8aRofLIOmHv
        yI/+8xmuQSQxUuUwRqlvo1V6tcwjjDL3wGbIC7l/rnKTTP/Ceg1k0maT5lbWt2sStS9PJM
        E10uuR4R3iw69cJRfUDDgfs77wRwQxi5ZMExvoXfw6qIOXgB3r+SpFHGvKOS0ap6MZLZ6s
        +AyB2V50AlSXw0Z3g7P0DZPfQmnomJYYmhs34xXovQk5NBvNNYSxgKrCCKMhGA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, piastryyy@gmail.com,
        smfrench@gmail.com, aaptel@suse.com
Cc:     Paulo Alcantara <pc@cjr.nz>, Duncan Findlay <duncf@duncf.ca>,
        Pavel Shilovsky <pshilov@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH] cifs: fix interrupted close commands
Date:   Wed, 13 Jan 2021 14:16:16 -0300
Message-Id: <20210113171616.11730-1-pc@cjr.nz>
In-Reply-To: <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
References: <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Retry close command if it gets interrupted to not leak open handles on
the server.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reported-by: Duncan Findlay <duncf@duncf.ca>
Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Fixes: 6988a619f5b7 ("cifs: allow syscalls to be restarted in __smb_send_rqst()")
Cc: stable@vger.kernel.org
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 067eb44c7baa..794fc3b68b4f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3248,7 +3248,7 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype, rsp);
 
 	/* retry close in a worker thread if this one is interrupted */
-	if (rc == -EINTR) {
+	if (is_interrupt_error(rc)) {
 		int tmp_rc;
 
 		tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,
-- 
2.29.2

