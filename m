Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E293E8098
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbhHJRu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhHJRtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:49:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D606861207;
        Tue, 10 Aug 2021 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617299;
        bh=QS1iM6ytuIb8alzj4lbpDhniECJ6zkis2ugGDqvVKJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBq/RUgsK1NCon+mPT4ImQ76ybLOgt6AqbTyUJD95DzaOFqPH3wjf/II0dCrMhv8+
         HIaM4sv02iBBiNjR0oqUFpx0zoKE7/CDTDK+x7dMUT0cIdvd4RV7nwCaxmgkWnMAJH
         pq/gaErutWigQOKPIrM8BvvXIL4gYqX6rsncuqeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/135] smb3: rc uninitialized in one fallocate path
Date:   Tue, 10 Aug 2021 19:31:07 +0200
Message-Id: <20210810173000.327496586@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



