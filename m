Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6164113334
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731253AbfLDSPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:43612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731423AbfLDSOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:14:16 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846FE20674;
        Wed,  4 Dec 2019 18:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575483256;
        bh=MBR4kE6kntoCbO0Wu7sIJIXGDvpYrsBMg0KIwE56k+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkULXJIAm/ZotmKAwEW7dydlpuPZVKY0HFyyHvfyzObm/+zIOsDDDg0QW2xjzNRGJ
         8yYGZc3bs+66RTsZQtpCCjwTOOimIlGZRJC8k+ecrAxz4kVq0//P1Bv+C7JEny3XIt
         h5uyBotLrbqxNKqtmkVnWgJ0U6rFuUeVBol1bNJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qi Jun Ding <qding@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 115/125] openvswitch: fix flow command message size
Date:   Wed,  4 Dec 2019 18:57:00 +0100
Message-Id: <20191204175326.136116021@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
References: <20191204175308.377746305@linuxfoundation.org>
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
@@ -738,9 +738,13 @@ static size_t ovs_flow_cmd_msg_size(cons
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


