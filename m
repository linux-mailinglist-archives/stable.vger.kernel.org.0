Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5BE3774B8
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 02:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEIAbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 20:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEIAbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 May 2021 20:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF3FC6108B;
        Sun,  9 May 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620520210;
        bh=c5rUftDWSwnr3jESMzj+4uzHzyLwnacoQCDOZWGMj+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CL3Pk8Qd3dvcw9eux0aYiqw53B6Q4DuK2/NCRmp+F+PkjUs+nRAXky3kLXLqX17HU
         pHEk0FawoTvXSVF8xADuR+KEHlQ5eAFlOAV6wB11S3uGoEbemSGacsSgNiPO0Y4d1T
         Y9gRld4EnGp1p83hRA28EYqKyYfDV0Vw+CxorWMw=
Date:   Sat, 8 May 2021 17:30:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        George Popescu <georgepope@android.com>,
        Elena Petrova <lenaptr@google.com>,
        Evgenii Stepanov <eugenis@google.com>, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS
 enabled
Message-Id: <20210508173009.781b8a401fefc2ab71cb3907@linux-foundation.org>
In-Reply-To: <20210506212025.815380-1-pcc@google.com>
References: <20210506212025.815380-1-pcc@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  6 May 2021 14:20:25 -0700 Peter Collingbourne <pcc@google.com> wrote:

> These tests deliberately access these arrays out of bounds,
> which will cause the dynamic local bounds checks inserted by
> CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> problem, access the arrays via volatile pointers, which will prevent
> the compiler from being able to determine the array bounds.

Huh.  Is this use of volatile the official way of suppressing the
generation of the checking code or is it just something which happened
to work?  I'm wondering if this workaround should be formalized in some
fashion (presumably a wrapper) rather than mysteriously and
unexplainedly open-coding it like this.

