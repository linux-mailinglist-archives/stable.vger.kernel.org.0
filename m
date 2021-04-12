Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C7235BF35
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbhDLJDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239848AbhDLJB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07CD06134F;
        Mon, 12 Apr 2021 08:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217972;
        bh=VETq8M92MQad2G4dgAI3fdGXIdBzdwZeeA/k/MwVQLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2BFCcSzIEiMNF9OAGbes2tDLH1vjEkZ85J5Vfk/MpdRF40QJnrKO8wwVZTHH9HwCA
         mY3/vh8xVqNpmxralIZhhYsCcGZIoQIjAR6LvJdaRmWjHOVlEp4g00vlOnriyHvGX9
         hbgjYz7AE5KxxSSxG1aCC+CFh1UWDsGczVIVnm+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciek Borzecki <maciek.borzecki@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.11 025/210] cifs: escape spaces in share names
Date:   Mon, 12 Apr 2021 10:38:50 +0200
Message-Id: <20210412084016.848914696@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciek Borzecki <maciek.borzecki@gmail.com>

commit 0fc9322ab5e1fe6910c9673e1a7ff29f7dd72611 upstream.

Commit 653a5efb849a ("cifs: update super_operations to show_devname")
introduced the display of devname for cifs mounts. However, when mounting
a share which has a whitespace in the name, that exact share name is also
displayed in mountinfo. Make sure that all whitespace is escaped.

Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
CC: <stable@vger.kernel.org> # 5.11+
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -475,7 +475,8 @@ static int cifs_show_devname(struct seq_
 		seq_puts(m, "none");
 	else {
 		convert_delimiter(devname, '/');
-		seq_puts(m, devname);
+		/* escape all spaces in share names */
+		seq_escape(m, devname, " \t");
 		kfree(devname);
 	}
 	return 0;


