Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE5282F27
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 05:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgJEDuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 23:50:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:58110 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJEDuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Oct 2020 23:50:20 -0400
IronPort-SDR: uptD8U17immlurGd9ENjXZK0RLD0Vob5upo6+ncnSA74Py9+rbuTzUrhLtX75zKUE20hulglvf
 oAhAMxh7nYbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="227459661"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="227459661"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:50:15 -0700
IronPort-SDR: +78de7BTlqIULS/Zxm5ve24hn9db3Xmtj/8xNCINYlnMzS6tR/HizVcMsHNpUKmwAymjxlVgtR
 BiOgwX62BQsg==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="295962488"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:50:11 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Safford <safford@watson.ibm.com>,
        keyrings@vger.kernel.org (open list:KEYS-TRUSTED),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] KEYS: trusted: Fix migratable=1 failing
Date:   Mon,  5 Oct 2020 06:49:48 +0300
Message-Id: <20201005034948.174228-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005034948.174228-1-jarkko.sakkinen@linux.intel.com>
References: <20201005034948.174228-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 security/keys/trusted-keys/trusted_tpm1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index c1dfc32c780b..20ca18e17437 100644
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
2.25.1

