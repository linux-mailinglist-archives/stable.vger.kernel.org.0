Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292FB35BD8C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhDLIwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238591AbhDLIuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D544B611F0;
        Mon, 12 Apr 2021 08:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217379;
        bh=bhM+djupoSUWstwVBxC/D+M76+T/q/4Dqj+tOjdDQiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hh70c/s12SIcX5F6UPxoq4nBnNc/h0TQmC2SuiZJde6B5/K8Kj8scbP2FbeYdwGLG
         9C28G6HR1OxBPUemwPJ5/xAsEEY6pT/3jSj2FoF0aNa1SPLZVvbbxVPH249Toxnl0K
         KATGA4VjUypxvVsd2PvFq9rcwkPbuID8866cagc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d946223c2e751d136c94@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.4 105/111] net: ieee802154: fix nl802154 del llsec dev
Date:   Mon, 12 Apr 2021 10:41:23 +0200
Message-Id: <20210412084007.767982487@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
@@ -1774,7 +1774,8 @@ static int nl802154_del_llsec_dev(struct
 	struct nlattr *attrs[NL802154_DEV_ATTR_MAX + 1];
 	__le64 extended_addr;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_DEVICE] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_DEV_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_DEVICE], nl802154_dev_policy, info->extack))
 		return -EINVAL;
 
 	if (!attrs[NL802154_DEV_ATTR_EXTENDED_ADDR])


