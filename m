Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568F148320C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiACOYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:24:00 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46310 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiACOXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:23:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 54EC3CE1110;
        Mon,  3 Jan 2022 14:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FFFC36AED;
        Mon,  3 Jan 2022 14:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219812;
        bh=vockE4d5UvlidGkv9Im4Rv4S0mFCwbAbZ40ui7n1iXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRNqQBiYdZSL3iz0t4HqWupn+2mZ9IuHOmoDf0PR4f54Ewq+m/McjWiUr3M57tSxu
         lTqs/2QXDfT5J42DaQJAZM0/myqHqv4wFA7DCWDLVw5Qj/1lK/JwiQcMlh6DjeGRIw
         NVOEKtPdravU/DYCoSONlgsb/Bxs0JWro6GPIFEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.14 05/19] selinux: initialize proto variable in selinux_ip_postroute_compat()
Date:   Mon,  3 Jan 2022 15:21:22 +0100
Message-Id: <20220103142052.241291041@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.068378906@linuxfoundation.org>
References: <20220103142052.068378906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 732bc2ff080c447f8524f40c970c481f5da6eed3 upstream.

Clang static analysis reports this warning

hooks.c:5765:6: warning: 4th function call argument is an uninitialized
                value
        if (selinux_xfrm_postroute_last(sksec->sid, skb, &ad, proto))
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

selinux_parse_skb() can return ok without setting proto.  The later call
to selinux_xfrm_postroute_last() does an early check of proto and can
return ok if the garbage proto value matches.  So initialize proto.

Cc: stable@vger.kernel.org
Fixes: eef9b41622f2 ("selinux: cleanup selinux_xfrm_sock_rcv_skb() and selinux_xfrm_postroute_last()")
Signed-off-by: Tom Rix <trix@redhat.com>
[PM: typo/spelling and checkpatch.pl description fixes]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5321,7 +5321,7 @@ static unsigned int selinux_ip_postroute
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	char *addrp;
-	u8 proto;
+	u8 proto = 0;
 
 	if (sk == NULL)
 		return NF_ACCEPT;


