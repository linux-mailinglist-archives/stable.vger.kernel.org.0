Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC5CA61C2
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfICGtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:49:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfICGtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 02:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tfxzcR/K46GlOQuPLSue8AsMiNtNZrvvJ84RvNiULXk=; b=iaF0QAsrwvsNe+FOgwFeI99W6
        U3M/XbSMFaHvkdH7HGdkT/JME96hhOlg/2g8CeA01UwDu+Kzjsd1NHobp3WelEQul88WVO4FjariX
        s+0oK0OPWcGvjjM2s9Cin+3b7fm/0MiUEaxK8VPJjGP1LJBBtdNJCd+tHuEkTmUzY5N4TMMCwEVem
        YVWnjXExgTnXyGUvV15MQjeJQoIWi+51qL1PQTzLH5Fcho7WJ5E8yI22dX52tHgcrjVMPJW27+4hE
        Kw7Ml+CUI9z1PYVEtnN4sCf6Zu+9acxnDTvzoEH7C0fMcyfY/fhvvpK3sAAeOGWyuaj+5wZ2jLQ/7
        rBwfXgWZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i52cs-0005r0-Bb; Tue, 03 Sep 2019 06:49:14 +0000
Date:   Mon, 2 Sep 2019 23:49:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] x86/platform/uv: Return UV Hubless System Type
Message-ID: <20190903064914.GA9914@infradead.org>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001815.893030884@stormcage.eag.rdlabs.hpecorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903001815.893030884@stormcage.eag.rdlabs.hpecorp.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>  static inline bool is_early_uv_system(void)
>  {
>  	return !((efi.uv_systab == EFI_INVALID_TABLE_ADDR) || !efi.uv_systab);

No need for the inner braces here.

But woudn't this be nicer as:

	return efi.uv_systab != EFI_INVALID_TABLE_ADDR && efi.uv_systab;

anyway?

> +#define is_uv_hubless _is_uv_hubless

Why the weird macro indirection?

> -static inline int is_uv_hubless(void)	{ return 0; }
> +static inline int _is_uv_hubless(int uv) { return 0; }
> +#define is_uv_hubless _is_uv_hubless

And here again.

