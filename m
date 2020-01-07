Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5511331C9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAGVDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgAGVDy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B7E2081E;
        Tue,  7 Jan 2020 21:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431034;
        bh=qQqkLG6E4zlxNyW71ejH7Xg6ZNSF3zn+NcXKNezev8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiIr8yTyknmDAemZk5w80NFsfxsIcumO2e5cFw5mi8kurtfVb2Byb1TllYNA4dmdu
         FZF634h8InI+9byBlAZ8pWtIpWHgUgbnytCUaLTmJt++swdxufgR1cJcOFts4yfppA
         HMprsuvWtqvAXEfw8Lryus4dHzD4M6a8L+XllpWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>,
        stfrench@microsoft.com, linux-cifs@vger.kernel.org
Subject: [PATCH 5.4 171/191] fs: cifs: Fix atime update check vs mtime
Date:   Tue,  7 Jan 2020 21:54:51 +0100
Message-Id: <20200107205342.153253181@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>

commit 69738cfdfa7032f45d9e7462d24490e61cf163dd upstream.

According to the comment in the code and commit log, some apps
expect atime >= mtime; but the introduced code results in
atime==mtime.  Fix the comparison to guard against atime<mtime.

Fixes: 9b9c5bea0b96 ("cifs: do not return atime less than mtime")
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: stfrench@microsoft.com
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -163,7 +163,7 @@ cifs_fattr_to_inode(struct inode *inode,
 
 	spin_lock(&inode->i_lock);
 	/* we do not want atime to be less than mtime, it broke some apps */
-	if (timespec64_compare(&fattr->cf_atime, &fattr->cf_mtime))
+	if (timespec64_compare(&fattr->cf_atime, &fattr->cf_mtime) < 0)
 		inode->i_atime = fattr->cf_mtime;
 	else
 		inode->i_atime = fattr->cf_atime;


