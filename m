Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707DF3C4BA5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhGLG6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239415AbhGLG5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 321286128D;
        Mon, 12 Jul 2021 06:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072879;
        bh=P8qrU43jfgJLpn/pAToQSjNm8URnaGL9yseGQMdHxaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1yNAL0BV5+9u4R7zzPxyUUkeCFj4v0N4peN2V3BU6a41PCtrtEiEk/5YczpFu4/+
         nKhVpd+Xoy9LYGJfwuVeqKtpJJD5HK/WmiywxB55yG4ChL6rvmmDCzqN9n+h3jI4qj
         5eJWsEUG0zGfBS/5Bvk8S9br2PS4M2GWxCmLgvoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 052/700] ext4: return error code when ext4_fill_flex_info() fails
Date:   Mon, 12 Jul 2021 08:02:15 +0200
Message-Id: <20210712060932.050543519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 8f6840c4fd1e7bd715e403074fb161c1a04cda73 upstream.

After commit c89128a00838 ("ext4: handle errors on
ext4_commit_super"), 'ret' may be set to 0 before calling
ext4_fill_flex_info(), if ext4_fill_flex_info() fails ext4_mount()
doesn't return error code, it makes 'root' is null which causes crash
in legacy_get_tree().

Fixes: c89128a00838 ("ext4: handle errors on ext4_commit_super")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210510111051.55650-1-yangyingliang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5039,6 +5039,7 @@ no_journal:
 			ext4_msg(sb, KERN_ERR,
 			       "unable to initialize "
 			       "flex_bg meta info!");
+			ret = -ENOMEM;
 			goto failed_mount6;
 		}
 


