Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF03360D4C
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhDOPB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234531AbhDOO5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:57:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4E0613FD;
        Thu, 15 Apr 2021 14:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498487;
        bh=6ckTbPMMaDUT4z/zGAWEqSYIUtGsOiCjYlVqascaMcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddP90ktK02j+s7xN92xw7DQ+O9e0WiR7eHiNZ5ijQQYvrBZIwTge+Pxi+VtK+a2yb
         85d1iNnlKANRa0MeB/f/DR6peJWVw+3l8IPQGVMoC8yEW+JBCIDxq5Jkf+U/0Up+62
         B9XrtFgdN6H6g5yfk2WnEBdr/bFdSkg5X70JwAOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.14 56/68] net: ieee802154: forbid monitor for set llsec params
Date:   Thu, 15 Apr 2021 16:47:37 +0200
Message-Id: <20210415144416.310527875@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 88c17855ac4291fb462e13a86b7516773b6c932e upstream.

This patch forbids to set llsec params for monitor interfaces which we
don't support yet.

Reported-by: syzbot+8b6719da8a04beeafcc3@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-3-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1402,6 +1402,9 @@ static int nl802154_set_llsec_params(str
 	u32 changed = 0;
 	int ret;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL802154_ATTR_SEC_ENABLED]) {
 		u8 enabled;
 


