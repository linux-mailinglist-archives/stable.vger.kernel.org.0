Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7748B0D3
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbiAKPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343559AbiAKPaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 10:30:09 -0500
X-Greylist: delayed 568 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Jan 2022 07:30:08 PST
Received: from smtp1.rz.tu-harburg.de (smtp1.rz.tu-harburg.de [IPv6:2001:638:702:20aa::205:38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED4BC06173F;
        Tue, 11 Jan 2022 07:30:08 -0800 (PST)
Received: from mail.tu-harburg.de (mail4.rz.tu-harburg.de [134.28.202.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.tuhh.de", Issuer "DFN-Verein Global Issuing CA" (verified OK))
        by smtp1.rz.tu-harburg.de (Postfix) with ESMTPS id 4JYDsb1h8QzxQq;
        Tue, 11 Jan 2022 16:20:35 +0100 (CET)
Received: from mailspring.rz.tuhh.de (mailspring.rz.tuhh.de [134.28.202.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: ccd5802@KERBEROS.TU-HARBURG.DE)
        by mail.tu-harburg.de (Postfix) with ESMTPSA id 4JYDsZ6RY3zJrCR;
        Tue, 11 Jan 2022 16:20:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tuhh.de; s=x2022-02;
        t=1641914435; bh=8GuvIwBs7ovGVIvnquMsGzYMmOCEN4T5kbsYciLAS+Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
         MIME-Version:Content-Type:Content-Transfer-Encoding;
        b=FuAOuSwmlnwrXKTVZo/bcKXWg+sx55PM/WLJR9Gwr6qyfThnjjH0or3k/B+/caxXE
         wvJD54juVxJ1dRfrkeF5MxzsZ4XWWmYeKIM2rR1swA6LrccbryUYXDGIP8wBNtEHrZ
         k6EJ63Z3TA5Uh8iarOJRvNPHvQYyTQblDW8n+TaI=
From:   Christian Dietrich <christian.dietrich@tuhh.de>
To:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/pgtable: define pte_index so that preprocessor could
 recognize it
In-Reply-To: <20220111145457.20748-1-rppt@kernel.org>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
References: <20220111145457.20748-1-rppt@kernel.org>
X-Commit-Hash-org: be34895d941bc0bcda2c4fd2ee2635b1dff29854
X-Commit-Hash-Maildir: 1f1ade09091bf6c540fef308030f9f5940906d6f
Date:   Tue, 11 Jan 2022 16:20:34 +0100
Message-ID: <s7bzgo2cn99.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Mike!

Mike Rapoport <rppt@kernel.org> [11. Januar 2022]:

> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e24d2c992b11..d468efcf48f4 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -62,6 +62,7 @@ static inline unsigned long pte_index(unsigned long add=
ress)
>  {
>  	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
>  }
> +#define pte_index pte_index

Wouldn't it make sense to remove the dead CPP blocks (#ifdef pte_index)
from mm/memory.c? Or is there a case were pte_index is not defined for
an architecture?

chris
--=20
Prof. Dr.-Ing. Christian Dietrich
Operating System Group (E-EXK4)
Technische Universit=C3=A4t Hamburg
Am Schwarzenberg-Campus 3 (E), 4.092
21073 Hamburg

eMail:  christian.dietrich@tuhh.de
Tel:    +49 40 42878 2188
WWW:    https://osg.tuhh.de/
