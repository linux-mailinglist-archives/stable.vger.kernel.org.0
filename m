Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC9243C44
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHMPLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 11:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgHMPLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 11:11:40 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9170C061383
        for <stable@vger.kernel.org>; Thu, 13 Aug 2020 08:11:39 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z6so7649106iow.6
        for <stable@vger.kernel.org>; Thu, 13 Aug 2020 08:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6ARAzTzN5CUt3iEIec1gXbW6uZcjZXtFNQf3WdyA8Cw=;
        b=eAx22CkjNQD3x8PGuwzaRHkqMf4zKwB9BcZ6h/r9Z/juNsCRoSTJowd71no9/skVbE
         qioiwuHeHMjOncsjTAsNaSBx8wOO5I9hBWk0Y9I5hane7I8xH5n3cy3FE5p8rMpIU1Bc
         YB9PgSzK/Rdjs9V7O2xzPynWT16CBccyNsaKU+RyPE0gMRij/DwdeoSCzsLVlE2JQY9g
         yVpfypIrBIer92kg2wPZa79/Z2itXshXp7plxd/w72/UlYbGP0XM8Y1TdKGrptw5olrr
         05/lROvax74sA2Z6L2X3Ap4IBgm36g+VqFtWDOwlcH7/T9s88jccQu01bQYRsLpHyP0M
         Id1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ARAzTzN5CUt3iEIec1gXbW6uZcjZXtFNQf3WdyA8Cw=;
        b=YKD9UKfOwMnqgmF921QKoU7143UrBxyP/wstmnQwXOIp5tHg4CYQcOwOWkGaOhZHTS
         g4c7jzDjHbWCpuu6XJH2V2r1HV6orsGpzvMHZeWmAGTNMLmwH9DJqktPMVoYijdSrQ5+
         uFzCtzHjlc+BA7RxgHXbb4sAW5/sCr3aFwnmXwo6OyhxfrEYg3OURVGHi6SrOECgBW9R
         a6If+O84r1Nx8iNFYenV4JdCyT/nxGdX8ro5RV8lkt+vOQCv/Rw1Du5XA8Ec7IC+ylZR
         /oNvH6dsTmIsIOiTwktUlFWF9UtWapdQJG3yFDaiI/0LYlbKmdJtSDrgIXgd8I2pqa3k
         9A/w==
X-Gm-Message-State: AOAM533TxU1RsalMvBYXvihabSkbeK+dmZ2LW3DlbNBulFD9ClptmpSG
        YpYtpldcIQjCWXv93ShgcN6KwlJj4RA=
X-Google-Smtp-Source: ABdhPJxiBTXqLt+ObC1M20JS7MpJnp5NsSIpP9Hg3FmxWHh70mgv57EXu+NmIRTBmHTP9FjDXHabHQ==
X-Received: by 2002:a02:a389:: with SMTP id y9mr5372382jak.82.1597331499112;
        Thu, 13 Aug 2020 08:11:39 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m7sm2839033ilq.45.2020.08.13.08.11.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 08:11:38 -0700 (PDT)
Subject: Fwd: [PATCH] fs/io_uring.c: Fix uninitialized variable is referenced
 in io_submit_sqe
References: <20200813065644.GA91891@ubuntu>
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
X-Forwarded-Message-Id: <20200813065644.GA91891@ubuntu>
Message-ID: <d62db5aa-c821-367b-6188-e9dc9bd1a0f0@kernel.dk>
Date:   Thu, 13 Aug 2020 09:11:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200813065644.GA91891@ubuntu>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Can you queue this up for 5.4 as well? Thanks!


-------- Forwarded Message --------
Subject: [PATCH] fs/io_uring.c: Fix uninitialized variable is referenced in io_submit_sqe
Date: Wed, 12 Aug 2020 23:56:44 -0700
From: Liu Yong <pkfxxxing@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
CC: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

the commit <a4d61e66ee4a> ("<io_uring: prevent re-read of sqe->opcode>") 
caused another vulnerability. After io_get_req(), the sqe_submit struct 
in req is not initialized, but the following code defaults that 
req->submit.opcode is available.

Signed-off-by: Liu Yong <pkfxxxing@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be3d595a607f..c1aaee061dae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2559,6 +2559,7 @@ static void io_submit_sqe(struct io_ring_ctx *ctx, struct sqe_submit *s,
 		goto err;
 	}
 
+	memcpy(&req->submit, s, sizeof(*s));
 	ret = io_req_set_file(ctx, s, state, req);
 	if (unlikely(ret)) {
 err_req:
-- 
2.17.1

