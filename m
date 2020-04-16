Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1451AC3AD
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388486AbgDPNqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898623AbgDPNqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:46:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D9AF2076D;
        Thu, 16 Apr 2020 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044804;
        bh=ESA2Q8qNEyYMT9qiYnzTb8YCAnx8roVpY6pxsaqV8pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4qdNtmKwgw2qo4P7RxvBOlcj2dRdkRFLpeT6nr/pRuls/RTb9xAtTj65GRBF3wpj
         q0ADhnSIFn0JCjlSSAwxs5UEeILYkJBndm15OIIWvhjrDCX+LC5A1HGYN04861H6bj
         ItXO+Bes25i/bpfD5fhbc9xSIga0beSptJArWFK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.4 108/232] KEYS: reaching the keys quotas correctly
Date:   Thu, 16 Apr 2020 15:23:22 +0200
Message-Id: <20200416131328.658431947@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Xu <xuyang2018.jy@cn.fujitsu.com>

commit 2e356101e72ab1361821b3af024d64877d9a798d upstream.

Currently, when we add a new user key, the calltrace as below:

add_key()
  key_create_or_update()
    key_alloc()
    __key_instantiate_and_link
      generic_key_instantiate
        key_payload_reserve
          ......

Since commit a08bf91ce28e ("KEYS: allow reaching the keys quotas exactly"),
we can reach max bytes/keys in key_alloc, but we forget to remove this
limit when we reserver space for payload in key_payload_reserve. So we
can only reach max keys but not max bytes when having delta between plen
and type->def_datalen. Remove this limit when instantiating the key, so we
can keep consistent with key_alloc.

Also, fix the similar problem in keyctl_chown_key().

Fixes: 0b77f5bfb45c ("keys: make the keyring quotas controllable through /proc/sys")
Fixes: a08bf91ce28e ("KEYS: allow reaching the keys quotas exactly")
Cc: stable@vger.kernel.org # 5.0.x
Cc: Eric Biggers <ebiggers@google.com>
Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/keys/key.c    |    2 +-
 security/keys/keyctl.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -381,7 +381,7 @@ int key_payload_reserve(struct key *key,
 		spin_lock(&key->user->lock);
 
 		if (delta > 0 &&
-		    (key->user->qnbytes + delta >= maxbytes ||
+		    (key->user->qnbytes + delta > maxbytes ||
 		     key->user->qnbytes + delta < key->user->qnbytes)) {
 			ret = -EDQUOT;
 		}
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -937,8 +937,8 @@ long keyctl_chown_key(key_serial_t id, u
 				key_quota_root_maxbytes : key_quota_maxbytes;
 
 			spin_lock(&newowner->lock);
-			if (newowner->qnkeys + 1 >= maxkeys ||
-			    newowner->qnbytes + key->quotalen >= maxbytes ||
+			if (newowner->qnkeys + 1 > maxkeys ||
+			    newowner->qnbytes + key->quotalen > maxbytes ||
 			    newowner->qnbytes + key->quotalen <
 			    newowner->qnbytes)
 				goto quota_overrun;


