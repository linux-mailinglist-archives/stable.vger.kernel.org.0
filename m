Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FA91AC276
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895807AbgDPN2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895787AbgDPN2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B638E21BE5;
        Thu, 16 Apr 2020 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043715;
        bh=BamNKXhfNiFIPXsfMP57heTe3HPRT8zjnwY/cjSBLY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WetpIXFKwaiSu7+XE0mjzYC4cSsw1Q3ixukp6vPaP0am5ekr2bRSS+UXHUsThhEOc
         AiUCRqeh3CFwRl6LGuXaQ4HNGNVDK6z1Y4/yUu+/l9FCTzDg9n4ctFexQLYDyIN4aV
         l+NVzwjTg/xgL9f5VY95Ma+toF4Oppwbvf2JuvuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4.19 069/146] tpm: tpm1_bios_measurements_next should increase position index
Date:   Thu, 16 Apr 2020 15:23:30 +0200
Message-Id: <20200416131252.401580845@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit d7a47b96ed1102551eb7325f97937e276fb91045 upstream.

If .next function does not change position index,
following .show function will repeat output related
to current position index.

In case of /sys/kernel/security/tpm0/ascii_bios_measurements
and binary_bios_measurements:
1) read after lseek beyound end of file generates whole last line.
2) read after lseek to middle of last line generates
expected end of last line and unexpected whole last line once again.

Cc: stable@vger.kernel.org # 4.19.x
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/eventlog/tpm1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tpm/eventlog/tpm1.c
+++ b/drivers/char/tpm/eventlog/tpm1.c
@@ -129,6 +129,7 @@ static void *tpm1_bios_measurements_next
 	u32 converted_event_size;
 	u32 converted_event_type;
 
+	(*pos)++;
 	converted_event_size = do_endian_conversion(event->event_size);
 
 	v += sizeof(struct tcpa_event) + converted_event_size;
@@ -146,7 +147,6 @@ static void *tpm1_bios_measurements_next
 	    ((v + sizeof(struct tcpa_event) + converted_event_size) >= limit))
 		return NULL;
 
-	(*pos)++;
 	return v;
 }
 


