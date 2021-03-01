Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE97328D72
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240968AbhCATL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240795AbhCATGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA1065144;
        Mon,  1 Mar 2021 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618282;
        bh=oM3VnJ6m/C9CkbW6odQsd7oV4wHBBxj5egG09vHfDXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7VujfUgf87cVyFPZePJdrLwLHoqOZx6YzwGzplVfRIehDoLKyf7R2iVOmYdNqYUV
         Y0WjSVLqrEKwncDaV1KfM4VpnAK1qmNQLXfO+LwK1zMkJ94Pk0wL5BYHZImFOtYt5q
         Bkg9/LTfLENr/Sg463g+1h8waBKpH5rEZvS1SwmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Michael Walle <michael@walle.cc>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 003/663] debugfs: be more robust at handling improper input in debugfs_lookup()
Date:   Mon,  1 Mar 2021 17:04:11 +0100
Message-Id: <20210301161141.944974108@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit bc6de804d36b3709d54fa22bd128cbac91c11526 upstream.

debugfs_lookup() doesn't like it if it is passed an illegal name
pointer, or if the filesystem isn't even initialized yet.  If either of
these happen, it will crash the system, so fix it up by properly testing
for valid input and that we are up and running before trying to find a
file in the filesystem.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: stable <stable@vger.kernel.org>
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
Tested-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210218100818.3622317-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/debugfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -297,7 +297,7 @@ struct dentry *debugfs_lookup(const char
 {
 	struct dentry *dentry;
 
-	if (IS_ERR(parent))
+	if (!debugfs_initialized() || IS_ERR_OR_NULL(name) || IS_ERR(parent))
 		return NULL;
 
 	if (!parent)


