Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDC610D77F
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 15:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfK2OxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 09:53:13 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:14388 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbfK2OxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 09:53:13 -0500
Received: from localhost (mailhub1-ext [192.168.12.233])
        by localhost (Postfix) with ESMTP id 47PcvB6MnFzB09Zt;
        Fri, 29 Nov 2019 15:53:10 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=hMUZ4aXd; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id XnpC7onj2i1L; Fri, 29 Nov 2019 15:53:10 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 47PcvB52GTzB09Zq;
        Fri, 29 Nov 2019 15:53:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1575039190; bh=C9qHRC2OmRsVO674EVzJC8ZRALO7qDaNoXi/6fn9Hv0=;
        h=To:Cc:From:Subject:Date:From;
        b=hMUZ4aXdvBS/0nRJH7MNGSgFKVDU/FPm1rUFedtxjbTOi060NfFdy8ouu8c7Eh5RI
         ku9P+IGf6U/4bSXMaYifdoFxMl229B4jZrmpMpdKsCgS+Bj9xbc5BKnSwoVwShCIf+
         DCF8P08TYsOZpBX2/TyaSGyIMuqRnaX0WZhVv54Q=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E14B78B8DE;
        Fri, 29 Nov 2019 15:53:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 1lPhm1XL-pIn; Fri, 29 Nov 2019 15:53:11 +0100 (CET)
Received: from po16098vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9894A8B8DC;
        Fri, 29 Nov 2019 15:53:11 +0100 (CET)
To:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: Build failure on latest powerpc/merge (311ae9e159d8 io_uring: fix
 dead-hung for non-iter fixed rw)
Message-ID: <71cf82d5-5986-43b7-cf1c-acba429a89d6@c-s.fr>
Date:   Fri, 29 Nov 2019 14:53:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

   CC      fs/io_uring.o
fs/io_uring.c: In function ‘loop_rw_iter’:
fs/io_uring.c:1628:21: error: implicit declaration of function ‘kmap’ 
[-Werror=implicit-function-declaration]
     iovec.iov_base = kmap(iter->bvec->bv_page)
                      ^
fs/io_uring.c:1628:19: warning: assignment makes pointer from integer 
without a cast [-Wint-conversion]
     iovec.iov_base = kmap(iter->bvec->bv_page)
                    ^
fs/io_uring.c:1643:4: error: implicit declaration of function ‘kunmap’ 
[-Werror=implicit-function-declaration]
     kunmap(iter->bvec->bv_page);
     ^


Reverting commit 311ae9e159d8 ("io_uring: fix dead-hung for non-iter 
fixed rw") clears the failure.

Most likely an #include is missing.


Christophe

