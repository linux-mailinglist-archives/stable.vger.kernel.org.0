Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D8111E4D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbfLCXAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:00:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfLCW52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:57:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F04520656;
        Tue,  3 Dec 2019 22:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413847;
        bh=aC1dVxvdq8PyZZwSvJVJJu1e/NRFcdnQdCPGZ0CjNE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7bb7fkUezNH+p0z1jNoI0hHXT9YUqpYhP61pT4RPdM2EeX3SWgxETd6HeNtxCwM4
         kB+75c4DOnmTXhbGJparQLbM7BPkZoUxZgj66LyT3SN0F6t5iU4U5LgkDcLc/piEmF
         5Yq+iaXicQ3UqQicLnbwuY18MGJ4y53ZlHgEMqmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qi Jun Ding <qding@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 284/321] openvswitch: fix flow command message size
Date:   Tue,  3 Dec 2019 23:35:50 +0100
Message-Id: <20191203223441.910383949@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 4e81c0b3fa93d07653e2415fa71656b080a112fd ]

When user-space sets the OVS_UFID_F_OMIT_* flags, and the relevant
flow has no UFID, we can exceed the computed size, as
ovs_nla_put_identifier() will always dump an OVS_FLOW_ATTR_KEY
attribute.
Take the above in account when computing the flow command message
size.

Fixes: 74ed7ab9264c ("openvswitch: Add support for unique flow IDs.")
Reported-by: Qi Jun Ding <qding@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -697,9 +697,13 @@ static size_t ovs_flow_cmd_msg_size(cons
 {
 	size_t len = NLMSG_ALIGN(sizeof(struct ovs_header));
 
-	/* OVS_FLOW_ATTR_UFID */
+	/* OVS_FLOW_ATTR_UFID, or unmasked flow key as fallback
+	 * see ovs_nla_put_identifier()
+	 */
 	if (sfid && ovs_identifier_is_ufid(sfid))
 		len += nla_total_size(sfid->ufid_len);
+	else
+		len += nla_total_size(ovs_key_attr_size());
 
 	/* OVS_FLOW_ATTR_KEY */
 	if (!sfid || should_fill_key(sfid, ufid_flags))


