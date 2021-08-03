Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA00F3DECA7
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 13:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhHCLox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 07:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236220AbhHCLoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3560460F11;
        Tue,  3 Aug 2021 11:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991059;
        bh=QS1iM6ytuIb8alzj4lbpDhniECJ6zkis2ugGDqvVKJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSepgHdAiJ8m3/CtCGHDsoG+zYK4VByjS6UmG9lSUQ2yV+6geM3k1+fzKOZv+oTD+
         dvyMcYXU+tVldJE4ctVR39Z6vQUM2u9n7vHsdImQz0AWL8LqfwunqQGZHfN/fmBtwn
         0mSIlHUD6yKlw98U0Otbl22LhPzdwnqKjztsAkNDxpexKxHCfKMITye8t1jQ2TprYM
         F6fJfr0+ECUeHx2FNqOf+yT2V6N88eerrkODFagZWUDqrnVjm/lEkvMpITgMsl102M
         gr4mlmfFyhU4GmaooH690HrS2AzSRW2GVqhuUN+MFZTQ+iMOD7BruBLADLJyeHWC9Q
         mvhBG5pMYRYzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Paulo Alcantara <pc@cjr.nz>, Sasha Levin <sashal@kernel.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 8/9] smb3: rc uninitialized in one fallocate path
Date:   Tue,  3 Aug 2021 07:44:07 -0400
Message-Id: <20210803114408.2252713-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114408.2252713-1-sashal@kernel.org>
References: <20210803114408.2252713-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 5ad4df56cd2158965f73416d41fce37906724822 ]

Clang detected a problem with rc possibly being unitialized
(when length is zero) in a recently added fallocate code path.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 81e087723777..fdb1d660bd13 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3466,7 +3466,8 @@ static int smb3_simple_fallocate_write_range(unsigned int xid,
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int rc, nbytes;
+	int nbytes;
+	int rc = 0;
 	struct kvec iov[2];
 
 	io_parms.netfid = cfile->fid.netfid;
-- 
2.30.2

