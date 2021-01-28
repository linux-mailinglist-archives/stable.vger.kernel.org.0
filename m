Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16B2308224
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 00:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhA1X5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 18:57:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhA1X5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 18:57:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D2B264E02;
        Thu, 28 Jan 2021 23:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611878196;
        bh=ylgnRUcnVlVEML2L+Q2zHIzNb950gPDfnP5/qgF/5w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrXiXIFh00kcRXXhwlDNHvOsGwjKIUQRm6utI+7ZdNn7j9oJUD08YmHca09c1IFpy
         u1nw3foOBBbMWENLvh14Mlsdix5T6w7L/No8seRBiZwWAlslDfZqcjG9nR9QzUPQeW
         oZaZTHmKkUtg79fbEG4I4yRnfzl75qotps92HDszaiQLcDtuFWfddFgaBCp/30lVV2
         zSt0ZkDCy45HRZicfCotPpVaR40gYHGNGJUxPrvh2lZA2Rpi4WKF+g9Z5vJgVNqvME
         Ku2THvdD3wta9hphXawto1ZpU9kJzrRui0I9uAxmeq0g0qLyVkjvmZ2cj0E9wg5xsB
         xQf/k3DkORaPQ==
From:   jarkko@kernel.org
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH v5 2/3] KEYS: trusted: Fix migratable=1 failing
Date:   Fri, 29 Jan 2021 01:56:20 +0200
Message-Id: <20210128235621.127925-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210128235621.127925-1-jarkko@kernel.org>
References: <20210128235621.127925-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko@kernel.org>

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
---
 security/keys/trusted-keys/trusted_tpm1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 204826b734ac..493eb91ed017 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -801,7 +801,7 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
 		case Opt_migratable:
 			if (*args[0].from == '0')
 				pay->migratable = 0;
-			else
+			else if (*args[0].from != '1')
 				return -EINVAL;
 			break;
 		case Opt_pcrlock:
-- 
2.30.0

