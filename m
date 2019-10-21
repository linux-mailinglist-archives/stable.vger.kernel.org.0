Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB096DF031
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 16:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfJUOpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 10:45:02 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43873 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJUOpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 10:45:02 -0400
Received: by mail-ot1-f68.google.com with SMTP id o44so11195721ota.10
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 07:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nXKBAnyH4k8+RtijsexqxpoxgeB4fhcJobwvx31LMho=;
        b=A08jDv+Vol6PvOoXT/M++kzuwcxp91LiBFYVYM8EPNPJr69L5QUHqGuyp6zGv7tyF9
         6FX/3oF06Fh+suEw+xQCGVLXW/2yTptC75eQ4/Bbh3WX6Ds/b0M7cf50hvpynQ5ibr4v
         gyYdRFItY3w55CEltwtFaefj+WsgXARJ5YWtFuxW73BsZK0zpcCSH1MoB0rLRv8RqmVt
         qiaRQW1K0uEwRHT9/yan1nEhEFofsZXJYLXFQRs8G0Luo67GpvQH6OEE/XLvxxr7bbTv
         RWxGf3MhxbRyjvhxwa7eDi1zMvw+87+x9G1yJ+8txjhDZ6FYAZefo+3fNI8vS/AdDEne
         vqOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nXKBAnyH4k8+RtijsexqxpoxgeB4fhcJobwvx31LMho=;
        b=B7SyZMnVNcE1hehXk61O78TIkG5sqKGcd+uUa6mGgW6nslIzrirSR9ZTpV3NW3ercN
         rH8BvAddSHKP1uwzj9MJinynNw0Xl3hdvHrl0eaZGO8z9HRkRS++MQD26yBlxRePdO91
         XttgjzjsU2A1pDutM4rrXyVsJAJC2qqxQYr8SlaT4klqVk6dwJ455crZ98/e8a2uVmBG
         nb3E8D8iWtLbpsLJP4eSn3veuaBzuO35tF4NDOIdei4IgzAi8fwhR4FpWdy7Gmp/wMC5
         JIJksI/lmEfRDKf8vvlnFSns7KNVNXzszm5Saa/RPcCvYuEfDlhZ4gaWiK0igLbgOD4H
         WQLQ==
X-Gm-Message-State: APjAAAVN9AjOiEgav+VppLZHWhk5p04ARJ5ONX1twpfy5RcHZ7vQ7JqF
        /xE9syiCLYbd+Nya3vEmtiIJELtQ8CGgSAwEO2HX0Q==
X-Google-Smtp-Source: APXvYqxBK0s4meOHW5S/bgvSxL00+aVLbFSn/xa462jwXlzSuPi3v0iK8imKwTC8RSn2iFmHXyu4Ls1dS51GrTPHPKE=
X-Received: by 2002:a9d:7c92:: with SMTP id q18mr19206153otn.363.1571669101455;
 Mon, 21 Oct 2019 07:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <157150237973.3940076.12626102230619807187.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x495zkii9o5.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x495zkii9o5.fsf@segfault.boston.devel.redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 21 Oct 2019 07:44:51 -0700
Message-ID: <CAPcyv4j66KoivrNRpOrqwrVtsOP5fSWKPqcHx_dDf1czy=f3qQ@mail.gmail.com>
Subject: Re: [PATCH] fs/dax: Fix pmd vs pte conflict detection
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jeff Smits <jeff.smits@intel.com>,
        Doug Nelson <doug.nelson@intel.com>,
        stable <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 21, 2019 at 5:07 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > Check for NULL entries before checking the entry order, otherwise NULL
> > is misinterpreted as a present pte conflict. The 'order' check needs to
> > happen before the locked check as an unlocked entry at the wrong order
> > must fallback to lookup the correct order.
>
> Please include the user-visible effects of the problem in the changelog.
>

Yup, I noticed that right after sending.
