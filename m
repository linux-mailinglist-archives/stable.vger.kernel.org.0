Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767E421C956
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgGLNJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 09:09:32 -0400
Received: from terminus.zytor.com ([198.137.202.136]:49995 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbgGLNJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 12 Jul 2020 09:09:31 -0400
Received: from carbon-x1.hos.anvin.org ([IPv6:2601:646:8600:3281:e7ea:4585:74bd:2ff0])
        (authenticated bits=0)
        by mail.zytor.com (8.15.2/8.15.2) with ESMTPSA id 06CD9KIY950515
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Sun, 12 Jul 2020 06:09:21 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 06CD9KIY950515
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020062301; t=1594559361;
        bh=DhxKjXp9j9Y+OP7wZRkqCMpDWKtGRRwN1/eUrDQnlI8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WKLLzGtAO5g2GMPmtY6lS1CTgbOzhjV3m5L2/acFl6QDxOTyosmNC90B6XvkuewMb
         PAuFw/HKQi/AZpvid2yAJk9IjthOv8k674kf6sE0sUAUYaqt0IcbLy+CIvImqS2mA8
         p51fRKaLqVA1FuIpsFFySaFLm2/dGns33TP2mpWj9VHIh6fuRsCablAIG1WSWLVhdR
         RANZ2LZbVmuJhBoH2Mb5N8KnVUcMlqmYtxAsR0+F/c6aHhr5jrrmNEBQwOO39kx02G
         svzSbowQgl+jSkUQAWnkRHh1zj5Slwq5RWubEo8RpJa8isCobD7o4HWJJAP9rX/nff
         6oX/vRpIn6qHA==
Subject: Re: [PATCH] decompress_bunzip2: fix sizeof type in start_bunzip
To:     trix@redhat.com, alain@knaff.lu
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200712125952.8809-1-trix@redhat.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <639c8ef5-2755-7172-fbb8-ce45c8637feb@zytor.com>
Date:   Sun, 12 Jul 2020 06:09:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200712125952.8809-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-07-12 05:59, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis flags this error
> 
> lib/decompress_bunzip2.c:671:13: warning: Result of 'malloc' is converted
>   to a pointer of type 'unsigned int', which is incompatible with sizeof
>   operand type 'int' [unix.MallocSizeof]
>         bd->dbuf = large_malloc(bd->dbufSize * sizeof(int));
>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reviewing the bunzip_data structure, the element dbuf is type
> 
> 	/* Intermediate buffer and its size (in bytes) */
> 	unsigned int *dbuf, dbufSize;
> 
> So change the type in sizeof to 'unsigned int'
> 

You must be kidding.

If you want to change it, change it to sizeof(bd->dbuf) instead, but this flag
is at least in my opinion a total joke. For sizeof(int) != sizeof(unsigned
int) is beyond bizarre, no matter how stupid the platform.

	-hpa

