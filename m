Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6243285BC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhCAQ6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:58:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235793AbhCAQwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:52:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4F8564FB1;
        Mon,  1 Mar 2021 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616394;
        bh=tJHUttpc1OBNchC98vG0su6aGYE8cWN7gyrCOJ6d7cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3imDv5n9vIDw41FAC1Gw2k3RERKjn5B8MgmRbc5ueILL6KhzxlQzYjdOBzs81uSg
         2H6V2uGQzOkn3A54H/PkkxnTzpafcPd0PI1L5tzADc3HUKABVbmmgXYjurbxTcKB4p
         nbmy7fyYVAeqWZqgxdHFOoQGXGk8Aiit9GQWLzB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.14 137/176] KEYS: trusted: Fix migratable=1 failing
Date:   Mon,  1 Mar 2021 17:13:30 +0100
Message-Id: <20210301161027.799803020@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 8da7520c80468c48f981f0b81fc1be6599e3b0ad upstream.

Consider the following transcript:

$ keyctl add trusted kmk "new 32 blobauth=helloworld keyhandle=80000000 migratable=1" @u
add_key: Invalid argument

The documentation has the following description:

  migratable=   0|1 indicating permission to reseal to new PCR values,
                default 1 (resealing allowed)

The consequence is that "migratable=1" should succeed. Fix this by
allowing this condition to pass instead of return -EINVAL.

[*] Documentation/security/keys/trusted-encrypted.rst

Cc: stable@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Fixes: d00a1c72f7f4 ("keys: add new trusted key-type")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -797,7 +797,7 @@ static int getoptions(char *c, struct tr
 		case Opt_migratable:
 			if (*args[0].from == '0')
 				pay->migratable = 0;
-			else
+			else if (*args[0].from != '1')
 				return -EINVAL;
 			break;
 		case Opt_pcrlock:


