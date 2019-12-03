Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAE6111C73
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfLCWoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:44:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728897AbfLCWoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:44:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 883FE206EC;
        Tue,  3 Dec 2019 22:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413051;
        bh=7Uq8hPue3t0dzfQ6bCUXlb0fNvdGnrh/7ADWJ5X9b/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AO32SfXqQx5lhcskQp5NFdldjnXjQE7CMT6y1BfVsXh/Kfc/ni7cZbO/OmOubrp/y
         rOYJd8mwrYuC+X5AeH1V4CMNcxYJkEBAl93kE92KFpke7iCgBcRAc8S1iiXBI3yoxk
         YiFSGj+gB2l58JBff17hphrJVTB7JWZI6Ri9icVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qi Jun Ding <qding@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 116/135] openvswitch: fix flow command message size
Date:   Tue,  3 Dec 2019 23:35:56 +0100
Message-Id: <20191203213043.318682472@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
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
@@ -701,9 +701,13 @@ static size_t ovs_flow_cmd_msg_size(cons
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


