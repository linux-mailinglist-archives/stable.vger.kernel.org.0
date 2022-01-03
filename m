Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B764832C9
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbiACOap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiACO3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CF4C06137C;
        Mon,  3 Jan 2022 06:29:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBE86610F4;
        Mon,  3 Jan 2022 14:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5B4C36AEB;
        Mon,  3 Jan 2022 14:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220154;
        bh=6pCikU2Fm7ZEK2XCYNwB4Vy+5UJpu5UD+099WR2pDxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phvrR6+OtaMmrw5pzF5Uz+LRAEjdJ/1NKU2LVHZ+CueNuJwdUVJ4zWfUt5yUlEMip
         hJo9A/vXnNXksqX/kmtY2aud2XHe5iktCAr3j2aYCc0EFJdjDB+aZGbso3vgtSncnl
         Ynkjw81hTvtW1SJmFXYdWWl0lcnzV+zVqnwU4CWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 09/48] selinux: initialize proto variable in selinux_ip_postroute_compat()
Date:   Mon,  3 Jan 2022 15:23:46 +0100
Message-Id: <20220103142053.792388751@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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
@@ -5665,7 +5665,7 @@ static unsigned int selinux_ip_postroute
 	struct common_audit_data ad;
 	struct lsm_network_audit net = {0,};
 	char *addrp;
-	u8 proto;
+	u8 proto = 0;
 
 	if (sk == NULL)
 		return NF_ACCEPT;


