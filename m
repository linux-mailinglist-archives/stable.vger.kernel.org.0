Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35DB35BD91
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhDLIwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238629AbhDLIuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8460F61243;
        Mon, 12 Apr 2021 08:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217393;
        bh=X46DoxFQl8+nxS+gbZtFAq6tuUmqeDUud71NR3H+K+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOjSb7Dhdy6N0I+64+SR5U1T2OL7yyJFbvAS/aYpZTGypwQnba/RtbnV2QYk9TBlI
         9GWxGs5IdrCN/jEx+BHdOK8ebHTOMqL/wEQbhcMtqKDZ7oPCxRjgT4hKsHn8haY06W
         Hlm4L3kOu7xosmmqKT2JmUaRVdUXZGbFxyj4o6n0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.4 109/111] net: ieee802154: forbid monitor for del llsec seclevel
Date:   Mon, 12 Apr 2021 10:41:27 +0200
Message-Id: <20210412084007.900564776@linuxfoundation.org>
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

commit 9dde130937e95b72adfae64ab21d6e7e707e2dac upstream.

This patch forbids to del llsec seclevel for monitor interfaces which we
don't support yet. Otherwise we will access llsec mib which isn't
initialized for monitors.

Reported-by: syzbot+fbf4fc11a819824e027b@syzkaller.appspotmail.com
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-15-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2108,6 +2108,9 @@ static int nl802154_del_llsec_seclevel(s
 	struct wpan_dev *wpan_dev = dev->ieee802154_ptr;
 	struct ieee802154_llsec_seclevel sl;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR)
+		return -EOPNOTSUPP;
+
 	if (!info->attrs[NL802154_ATTR_SEC_LEVEL] ||
 	    llsec_parse_seclevel(info->attrs[NL802154_ATTR_SEC_LEVEL],
 				 &sl) < 0)


