Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7612F149B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732396AbhAKNQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732390AbhAKNQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6B2C22B49;
        Mon, 11 Jan 2021 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370944;
        bh=lO/hqzSm60hQwX+e/+faTr95Q0PcWNOAaM67jIsDsDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TL976ki+KZhz+7Nfq5iHlSVGHFJDIO+ebyDeeQYPFQ2EVkdqrISjblWoJlm1I+Cfq
         SY7/p41snVqSsBt9GYtyxdGg3OidsZ5ky0HxmzxY1ZuS1i9txKtjvzt8KON7it/uWG
         v21+ZxxTzCQ2YCfMrfzw2W+Z6bnZ0ITtDnA340FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilil Blum Shem-Tov <ilil.blum.shem-tov@intel.com>
Subject: [PATCH 5.10 073/145] crypto: asym_tpm: correct zero out potential secrets
Date:   Mon, 11 Jan 2021 14:01:37 +0100
Message-Id: <20210111130052.036663551@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f93274ef0fe972c120c96b3207f8fce376231a60 upstream.

The function derive_pub_key() should be calling memzero_explicit()
instead of memset() in case the complier decides to optimize away the
call to memset() because it "knows" no one is going to touch the memory
anymore.

Cc: stable <stable@vger.kernel.org>
Reported-by: Ilil Blum Shem-Tov <ilil.blum.shem-tov@intel.com>
Tested-by: Ilil Blum Shem-Tov <ilil.blum.shem-tov@intel.com>
Link: https://lore.kernel.org/r/X8ns4AfwjKudpyfe@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/asymmetric_keys/asym_tpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -354,7 +354,7 @@ static uint32_t derive_pub_key(const voi
 	memcpy(cur, e, sizeof(e));
 	cur += sizeof(e);
 	/* Zero parameters to satisfy set_pub_key ABI. */
-	memset(cur, 0, SETKEY_PARAMS_SIZE);
+	memzero_explicit(cur, SETKEY_PARAMS_SIZE);
 
 	return cur - buf;
 }


