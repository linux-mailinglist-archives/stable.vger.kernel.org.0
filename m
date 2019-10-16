Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4FBD8926
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 09:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfJPHOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 03:14:09 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35652 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfJPHOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 03:14:09 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so22839730lji.2
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 00:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qJB3DgxYbX/jUqMyf+pgAYm9//vAPvM7RBIypiauqNc=;
        b=V6GrRUh8+pYJ2lOqM+Ya8lwdm+PkHXo8h04IYauYp0srqj6Xt+xYRg53QigHN7Lqqg
         O7uB49jV/vjMsfD8WnWi1ShTXmxeDYeE19mheNa41hInMzkmXY39CuVjnWwrHNc7713C
         AajWxJgjElBW9pGPXWsYmk8Ck1jjRbSDPwaPQQIYaiMPu4zA/0jfDGt0QytgDfYlV54S
         isqcLgTZ6JxxCh4MAM0Gq1LVKBSfdPVsibV1B/00ISKERqXfcqpfi9/mD3ThWRgn3ocw
         z8ClL6ay/SRbIWwwkOKrUYOZH1vg6XZwtM/sy1cmP+x6xdbmRTlzhKPblBYlf5bBbzQT
         Pr/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qJB3DgxYbX/jUqMyf+pgAYm9//vAPvM7RBIypiauqNc=;
        b=nym7c4SHxUQ2DUyjR82DLDLHdSNkIcnW6nV5NOGoIMtYDXRGYQJUCR2EphibQdpazk
         Nw/pAVm/Mn/TxciaKOXtnudli5dISNiNEgx3aE9eQsvs+yDpVEU2lLjKPuIUyM0JeyAj
         2NxYl0L1DtfBluiyGSJejxNnrzOgnJgUm/MxXC/V6YNj81S+YnaBoXtsVlNwgEhWr2Hp
         Cwr0BrjJqByrZ87uv9mPDcSvZHWN7QmDPSIhEWHb/7PgNxiPITEgSm3r/zfuDMFV9LjA
         4ndhsQ9jc+A4DSVr3KQDBhPesdfaNeeVAvv4SfQ1Xgh9Wxu/+It0WM1Eg0kAMjU7FLlf
         nfjQ==
X-Gm-Message-State: APjAAAUTin3saOQ5B6vXt97VzQsXoIX/SVhj1hTwaxQajd+emcLXX6YD
        g3sijNRacPFUl7LzwLOPMUc=
X-Google-Smtp-Source: APXvYqz73v2r6f0Pn5w3kKhOZhIFnhyNWeusiYXhxa3078eViBbB4ZbBn+msOI48WG4JODLnSNTpmQ==
X-Received: by 2002:a05:651c:1b9:: with SMTP id c25mr24015130ljn.163.1571210045684;
        Wed, 16 Oct 2019 00:14:05 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net (jcmvbkbc-1-pt.tunnel.tserv24.sto1.ipv6.he.net. [2001:470:27:1fa::2])
        by smtp.gmail.com with ESMTPSA id q19sm8182454lfj.9.2019.10.16.00.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 00:14:05 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] xtensa: fix change_bit in exclusive access option
Date:   Wed, 16 Oct 2019 00:13:52 -0700
Message-Id: <20191016071352.27688-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

change_bit implementation for XCHAL_HAVE_EXCLUSIVE case changes all bits
except the one required due to copy-paste error from clear_bit.

Cc: stable@vger.kernel.org # v5.2+
Fixes: f7c34874f04a ("xtensa: add exclusive atomics support")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/include/asm/bitops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index aeb15f4c755b..be8b2be5a98b 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -148,7 +148,7 @@ static inline void change_bit(unsigned int bit, volatile unsigned long *p)
 			"       getex   %0\n"
 			"       beqz    %0, 1b\n"
 			: "=&a" (tmp)
-			: "a" (~mask), "a" (p)
+			: "a" (mask), "a" (p)
 			: "memory");
 }
 
-- 
2.20.1

