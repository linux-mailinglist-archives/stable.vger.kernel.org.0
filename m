Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15DF21C953
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 15:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgGLNAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 09:00:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51159 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728686AbgGLNAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 09:00:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594558802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=tP1p0y5VuFxAzgtXgy/goQauifZ0DIQKOQPjri03c2c=;
        b=RJ575YqXzAi7P5VPuabcSaKwTkFLCOqOSfTrpa94OW5aGxLEB/G4eLxAp/KX01KTDci4tT
        2bqb8M7HbtFDXmjPtVJHQ4U42ImeuWW5QFusSamqvx/Tgv4E2nmo/iYm1+9jnzM1NMzamR
        +163EMAR5dij/cBF1sYSxO+TYSHcgL4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-WveKJr_nNSOnGy5gyZTuuw-1; Sun, 12 Jul 2020 09:00:00 -0400
X-MC-Unique: WveKJr_nNSOnGy5gyZTuuw-1
Received: by mail-qk1-f199.google.com with SMTP id z1so8660153qkz.3
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 06:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tP1p0y5VuFxAzgtXgy/goQauifZ0DIQKOQPjri03c2c=;
        b=GN/KgPD8FE7DIbeY4aYzkA2Pr4jKzGxT3Sbmrx/OBjl1GzkYMbt9xgi0VHoTOG+zHP
         t8axSXGsfhz0gOYqLHEmAo/8jiJ5BbA2l33sgjHW+zK1TMsggGxLT8Fwg2NDjmrNXAul
         U/ZEo5UGN9U3jttF7NnTBCLuWZ9dnS1LHY6slTCfzalHbunEFU9VUH7jqQQWf906f6B2
         iYp8wRHakQvNQWf+3RoLAdhsbKvsCW3LgRjhjSO0UNqyeLNVYYmbULCBHAsH5bQIRVXx
         PK4Pi2W1MtzzoHg4N+pvYtHMMi8iXQ/S1uP/itFfD5yxYCmQqkE688O8BX4WiCiD3czU
         6TWw==
X-Gm-Message-State: AOAM530ANb5vPZ28IK8YeZ1t5UJhqxvzpUSQBuk8+HAbzkEIVKs3rUAw
        2eqz/JM6GwGcaC7D6ohHF9//nkgcxqN1AM7DbDxkB95Fw9NulaxDwilEJ4A08BGAM7O6qNrMBcK
        kEDrDQ/WsXRThN7Qv
X-Received: by 2002:ac8:3544:: with SMTP id z4mr69890726qtb.68.1594558799662;
        Sun, 12 Jul 2020 05:59:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCFScybhjUoE2d3Vzjj9N9mrsMuV/Nq5PadBwjJZI0XXcjVFovcX7MaSls1X0DteDOlq8Amw==
X-Received: by 2002:ac8:3544:: with SMTP id z4mr69890709qtb.68.1594558799402;
        Sun, 12 Jul 2020 05:59:59 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id 21sm15294425qkj.56.2020.07.12.05.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 05:59:58 -0700 (PDT)
From:   trix@redhat.com
To:     hpa@zytor.com, alain@knaff.lu
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] decompress_bunzip2: fix sizeof type in start_bunzip
Date:   Sun, 12 Jul 2020 05:59:52 -0700
Message-Id: <20200712125952.8809-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags this error

lib/decompress_bunzip2.c:671:13: warning: Result of 'malloc' is converted
  to a pointer of type 'unsigned int', which is incompatible with sizeof
  operand type 'int' [unix.MallocSizeof]
        bd->dbuf = large_malloc(bd->dbufSize * sizeof(int));
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reviewing the bunzip_data structure, the element dbuf is type

	/* Intermediate buffer and its size (in bytes) */
	unsigned int *dbuf, dbufSize;

So change the type in sizeof to 'unsigned int'

Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 lib/decompress_bunzip2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 7c4932eed748..59ab76bda7a7 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -668,7 +668,7 @@ static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, long len,
 	   uncompressed data.  Allocate intermediate buffer for block. */
 	bd->dbufSize = 100000*(i-BZh0);
 
-	bd->dbuf = large_malloc(bd->dbufSize * sizeof(int));
+	bd->dbuf = large_malloc(bd->dbufSize * sizeof(unsigned int));
 	if (!bd->dbuf)
 		return RETVAL_OUT_OF_MEMORY;
 	return RETVAL_OK;
-- 
2.18.1

