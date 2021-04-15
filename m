Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C5A360D49
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhDOPB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233937AbhDOO5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB794613D5;
        Thu, 15 Apr 2021 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498479;
        bh=n1ltmhE0qiMgnUpH9RXCFq3nk5leOHJY/5C1eByrzHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXIU/x5Ylo2mPMv3+rp7bN8gBy5VX1ud9k7sjxUXH58DJ930haoyx/97n2mW54L3/
         Lq2It039NpWQAqkYwiBJlU5n8gAPdBvmrAWJvMkO7//mAEBcMK+5yyG97J5Lveuq9g
         71Y+gMXAwv2tQCLdXI0YkCJm5oCf5AqByju10zDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.14 53/68] net: ieee802154: fix nl802154 del llsec dev
Date:   Thu, 15 Apr 2021 16:47:34 +0200
Message-Id: <20210415144416.211759386@linuxfoundation.org>
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

commit 3d1eac2f45585690d942cf47fd7fbd04093ebd1b upstream.

This patch fixes a nullpointer dereference if NL802154_ATTR_SEC_DEVICE is
not set by the user. If this is the case nl802154 will return -EINVAL.

Reported-by: syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210221174321.14210-2-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1781,7 +1781,8 @@ static int nl802154_del_llsec_dev(struct
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
-	if (nla_parse_nested(attrs, NL802154_DEV_ATTR_MAX,
+	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
+	    nla_parse_nested(attrs, NL802154_DEV_ATTR_MAX,
 			     info->attrs[NL802154_ATTR_SEC_DEVICE],
 			     nl802154_dev_policy, info->extack))
 		return -EINVAL;


