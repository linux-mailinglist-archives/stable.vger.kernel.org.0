Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD5253E970
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbiFFOdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbiFFOdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:13 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6412B248;
        Mon,  6 Jun 2022 07:33:12 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l2-20020a05600c1d0200b0039c35ef94c4so5902227wms.4;
        Mon, 06 Jun 2022 07:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SzyQsb1o4fSk85fpWvWY8/HRYw+PK4Y1RJ618LPBXOE=;
        b=T5CRrkmg3r1UzZG2LLjrDRF/l413u2riFgZL8u86FhGjCdozXKk/HYAuRGaOlB4Fol
         jfwsZ86tRuox/xpaMePq/T5DwznaWubv7whYvT13uSeGC9gNRJ71Bu1+ytkmoSG0lpcO
         bhNL/3ejdmfsi4gnQIHaXHFwlFaxnjK66X6BGzi68pWImdQnA40n60M1+n/AgcPme7hL
         60dJMVG58x1SNdn82ToW6mOQL5TRfNQSGuauYW/VQPDljWU3SN5jHNO1EjEqIejcFSIK
         6cgV6AFBT6XWWm/ubTUQWDKWHC+kFY7dF3bUhcFeGf1zSmNBEGxZqSVFdvGja6Yn7j6F
         eUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SzyQsb1o4fSk85fpWvWY8/HRYw+PK4Y1RJ618LPBXOE=;
        b=n6y4F+FZnvCXpDlfB/8NMcbEjPAY+pHkmLOYpuknjILSnwWm0e3YUboGS6oklzgoED
         D4Zx3/lKEqDWKTD08+O+ma+toGPAoOmFiu7CmvzxEbqJZvGBA2pzRGQdM+wIHY7wuPFY
         XSGm51RFTNFbTtcxYCLcr9QBANidRsfZbxGy8WaLZsvx2UB4C5AuZDWVhSTqGFPMyOaJ
         XABdxvlMPvwgQ0sJLwZlH+hzRd8VwjB+UfzoRE8hav0pB+PbbygK7osovkcVJ1iKO2/8
         fbE3WMTonrfPWTBkH4Dqb1357AnURYr8oU/UL8wIH+4wJOpDT5LdEcQcxl8Q08CWXZAD
         Q2cg==
X-Gm-Message-State: AOAM532hudFGnOk2RBSkadBna4nx495pgOmj5HIeDKjG8TXBLkrDCtdB
        btjiMRteES8XHvnCPBkjxOQ=
X-Google-Smtp-Source: ABdhPJxU0b1GxwHBraCdgM9PVN1ZncTUb4oO3fgL83YJfb6c1ByhYEyN2dSYBm/Cg0S2jShQuyHAlw==
X-Received: by 2002:a7b:c758:0:b0:39c:44ce:f00f with SMTP id w24-20020a7bc758000000b0039c44cef00fmr13674785wmk.167.1654525990476;
        Mon, 06 Jun 2022 07:33:10 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 5.10 v2 5/8] xfs: restore shutdown check in mapped write fault path
Date:   Mon,  6 Jun 2022 17:32:52 +0300
Message-Id: <20220606143255.685988-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606143255.685988-1-amir73il@gmail.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit e4826691cc7e5458bcb659935d0092bcf3f08c20 upstream.

XFS triggers an iomap warning in the write fault path due to a
!PageUptodate() page if a write fault happens to occur on a page
that recently failed writeback. The iomap writeback error handling
code can clear the Uptodate flag if no portion of the page is
submitted for I/O. This is reproduced by fstest generic/019, which
combines various forms of I/O with simulated disk failures that
inevitably lead to filesystem shutdown (which then unconditionally
fails page writeback).

This is a regression introduced by commit f150b4234397 ("xfs: split
the iomap ops for buffered vs direct writes") due to the removal of
a shutdown check and explicit error return in the ->iomap_begin()
path used by the write fault path. The explicit error return
historically translated to a SIGBUS, but now carries on with iomap
processing where it complains about the unexpected state. Restore
the shutdown check to xfs_buffered_write_iomap_begin() to restore
historical behavior.

Fixes: f150b4234397 ("xfs: split the iomap ops for buffered vs direct writes")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_iomap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7b9ff824e82d..74bc2beadc23 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -870,6 +870,9 @@ xfs_buffered_write_iomap_begin(
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
 	/* we can't use delayed allocations when using extent size hints */
 	if (xfs_get_extsz_hint(ip))
 		return xfs_direct_write_iomap_begin(inode, offset, count,
-- 
2.25.1

