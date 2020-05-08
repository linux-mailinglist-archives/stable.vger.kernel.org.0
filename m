Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0CD1CAEBA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgEHMqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgEHMqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA9F21974;
        Fri,  8 May 2020 12:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941998;
        bh=0T222ILwSgvkoX/PFXNcY1qF0aAgs076Z9VE9QEqd7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJ+iS8fDnQVRb0HD/T0q4gnD4NLooqW6d7w77FXR4YKmi38Kh+nF3chL1WAY8ytgI
         jHbvtarC60tZUpfeAvafSc6ZIrCa6pnyEgsZ1ewyG/8pxGYakrgMuBdodwbASo8A58
         iDW8PfsdDKDyKiabJWyCePrzbCq1SOlMdnfluX8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 256/312] gre: reject GUE and FOU in collect metadata mode
Date:   Fri,  8 May 2020 14:34:07 +0200
Message-Id: <20200508123142.402612829@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

commit 946b636f1730c64e05ff7fe8cf7136422fa8ea70 upstream.

The collect metadata mode does not support GUE nor FOU. This might be
implemented later; until then, we should reject such config.

I think this is okay to be changed. It's unlikely anyone has such
configuration (as it doesn't work anyway) and we may need a way to
distinguish whether it's supported or not by the kernel later.

For backwards compatibility with iproute2, it's not possible to just check
the attribute presence (iproute2 always includes the attribute), the actual
value has to be checked, too.

Fixes: 2e15ea390e6f4 ("ip_gre: Add support to collect tunnel metadata.")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_gre.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -937,6 +937,11 @@ static int ipgre_tunnel_validate(struct
 	if (flags & (GRE_VERSION|GRE_ROUTING))
 		return -EINVAL;
 
+	if (data[IFLA_GRE_COLLECT_METADATA] &&
+	    data[IFLA_GRE_ENCAP_TYPE] &&
+	    nla_get_u16(data[IFLA_GRE_ENCAP_TYPE]) != TUNNEL_ENCAP_NONE)
+		return -EINVAL;
+
 	return 0;
 }
 


