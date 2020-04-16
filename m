Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB091AC787
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394821AbgDPO4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732182AbgDPN4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:56:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93AF220732;
        Thu, 16 Apr 2020 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045369;
        bh=1ClpcThwENIVjhgFj2BIfnEiPBTFpOMrznL6cQRlSt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ViF1dydqOOEypDST0JeDeldwEJzyi9gO3304A8JgKBzQLS8flkrYEXMn824zORiOD
         K6cz6X83TBSx03puNOwx7jA+KXiAJwfHzkV8x30IAe1pNYMF3F3y6HpvXrWdVDX6Yp
         cDEqZEO2GM34OzgQA/w7WrnA+nbuQ53l4B7uUutI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.6 107/254] tpm: tpm1_bios_measurements_next should increase position index
Date:   Thu, 16 Apr 2020 15:23:16 +0200
Message-Id: <20200416131339.494494210@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
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
@@ -115,6 +115,7 @@ static void *tpm1_bios_measurements_next
 	u32 converted_event_size;
 	u32 converted_event_type;
 
+	(*pos)++;
 	converted_event_size = do_endian_conversion(event->event_size);
 
 	v += sizeof(struct tcpa_event) + converted_event_size;
@@ -132,7 +133,6 @@ static void *tpm1_bios_measurements_next
 	    ((v + sizeof(struct tcpa_event) + converted_event_size) > limit))
 		return NULL;
 
-	(*pos)++;
 	return v;
 }
 


