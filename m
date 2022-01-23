Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841834970CD
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 10:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiAWJu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 04:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiAWJu1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 04:50:27 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA3DC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 01:50:27 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k18so8088616wrg.11
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 01:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vastdata.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RuNGBK5fcLDz16QYm/SZdAAhoFtbTtCIr23eV0j1CbY=;
        b=aCUvNhOgxiv7iEllvx7gkGwDmM11Q1V7U948L9VX/bdcrZAk0EguWnp1asEjJalQAe
         j6ubcaB8PedcJnIv7Tu157M0Fis6Avz11NPksdZ/xBsfwaLTK1ftvMdTSnGa47Q2eiOa
         aYk8pmzNfmm/cj4z48QD658LAxtqNktvPKjJS6bGWelJHny1KYUJYRea1AXoOrbqvTgb
         oOY+mrkjUGoVZXTgZ7PIMBC7mjOvwkjw6yHZnVcVl5CSQP6SKEOKo3zpL3kkAmOkwAvM
         E5GcLdHg2ph+SIrdeUmtZo82+9cBOn6EEson+SYvwMifWC1GKDkk4OjUZXzQqVpRIB7d
         6D7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RuNGBK5fcLDz16QYm/SZdAAhoFtbTtCIr23eV0j1CbY=;
        b=i333I46R0DezkMVZ0hMeypXj8pOcqJj3PQM2v2EWr6cpj/gZbtkGUWc6iLU0NwujHM
         AZytgUy1nZlMIPCzn/sErQ9cRTPyE0PScfJrLuwRC0A0KOo7r5Be890LiMUNvyOspEYk
         5xRvd9Ti8xlBwsW0GFJ9sESV2i1j5h1G8LlETD/UCDF3ZlssWLkfqgHxQMHDrSFHUTtu
         LZsR8+l9laT2tTB9itVnwgOx6dKgX2DfIBGzX1c0dpb45x2AJD47y2vSV9bsOHQyIBXQ
         0TrvlhZKNVRBQoJraONTkWhrbSDe1+jssKjMwmXGmSyTjNoO74gJXTmiuCyl6lfUDBy2
         DTtA==
X-Gm-Message-State: AOAM533RZtaV4p7yy526syabHj4bmqlBGW8RpWSMuzgPR7ITQ7LXVnOO
        7VJLfnJKQEZ9AHI2UttmNPcNgg==
X-Google-Smtp-Source: ABdhPJx/8uQt9m559xgwEP6XRP2PrC7Kt3y0ER9D4MSUWqaFcYyBZqVDD2XFnP/n6AV71YxH3ERPmQ==
X-Received: by 2002:a5d:6510:: with SMTP id x16mr1244087wru.613.1642931425997;
        Sun, 23 Jan 2022 01:50:25 -0800 (PST)
Received: from jupiter.lan ([77.125.69.23])
        by smtp.gmail.com with ESMTPSA id v5sm15617006wmh.19.2022.01.23.01.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 01:50:25 -0800 (PST)
From:   Dan Aloni <dan.aloni@vastdata.com>
To:     chuck.lever@oracle.com
Cc:     Anna Schumaker <Anna.Schumaker@netapp.com>,
        linux-nfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3] NFSD: trim reads past NFS_OFFSET_MAX and fix NFSv3 check
Date:   Sun, 23 Jan 2022 11:50:23 +0200
Message-Id: <20220123095023.2775411-1-dan.aloni@vastdata.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <ADEC85C2-8D72-4E25-A49B-2039C1FF82F2@oracle.com>
References: <ADEC85C2-8D72-4E25-A49B-2039C1FF82F2@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Due to commit 8cfb9015280d ("NFS: Always provide aligned buffers to the
RPC read layers") on the client, a read of 0xfff is aligned up to server
rsize of 0x1000.

As a result, in a test where the server has a file of size
0x7fffffffffffffff, and the client tries to read from the offset
0x7ffffffffffff000, the read causes loff_t overflow in the server and it
returns an NFS code of EINVAL to the client. The client as a result
indefinitely retries the request.

This fixes the issue at server side by trimming reads past
NFS_OFFSET_MAX. It also adds a missing check for out of bound offset in
NFSv3, copying a similar check from NFSv4.x.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
---
 fs/nfsd/nfs4proc.c | 3 +++
 fs/nfsd/vfs.c      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 486c5dba4b65..816bdf212559 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -785,6 +785,9 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (read->rd_offset >= OFFSET_MAX)
 		return nfserr_inval;
 
+	if (unlikely(read->rd_offset + read->rd_length > OFFSET_MAX))
+		read->rd_length = OFFSET_MAX - read->rd_offset;
+
 	trace_nfsd_read_start(rqstp, &cstate->current_fh,
 			      read->rd_offset, read->rd_length);
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 738d564ca4ce..ad4df374433e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1045,6 +1045,12 @@ __be32 nfsd_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct file *file;
 	__be32 err;
 
+	if (unlikely(offset >= NFS_OFFSET_MAX))
+		return nfserr_inval;
+
+	if (unlikely(offset + *count > NFS_OFFSET_MAX))
+		*count = NFS_OFFSET_MAX - offset;
+
 	trace_nfsd_read_start(rqstp, fhp, offset, *count);
 	err = nfsd_file_acquire(rqstp, fhp, NFSD_MAY_READ, &nf);
 	if (err)
-- 
2.23.0

