Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE982215A1D
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgGFO7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 10:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbgGFO7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 10:59:01 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E67C061755;
        Mon,  6 Jul 2020 07:59:01 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x62so29149575qtd.3;
        Mon, 06 Jul 2020 07:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ry1RpVAEDjDLCs5jpWgNEsfeNNgUahwX2prGBgFkAOU=;
        b=LUmTPMf5mmAgukBOW1BCsZ9FagomTLGbESXBWtoa2RJ2ZwucTPRq7Ri2KvyQA/HpHa
         8pizs6iLDVo4+l+zATwQAGnjVXzSREMVSfWd837YEhQYD/KxIDaoNhKsH6ag/zcswwiR
         +v6Ic4Apb8Kaa7aYzWJEhhB+QhWa2ZAu2TXd6wdbojP4fiBQq+AUNtU4H5SfFNRRVwnm
         on/C1L8EToHj1d75h8Utb+WKCzRpavTBd4+cVa3cSF8zqxef/X8c6Gs4Mbr/J1TiBu4t
         pWEpbTQ/fsQzZ/hzBlyEkAc26KWRTQSRTFd46GJIIlLj+f3CDf4NDOH+KJ9bSnFIoUz6
         PFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Ry1RpVAEDjDLCs5jpWgNEsfeNNgUahwX2prGBgFkAOU=;
        b=VnlYGz/xaKFrdlKMlYBiEOFaggJTtSP122JqtBbMDxJeqloDcv+t20sWJHv/jIuSKZ
         gB1WnOrQJcyA9gBr4o5Dh8sG9kf+Gnwmmaov7dlfCs7Jq2wHyUUsWHvOSNAimF576sGt
         UreoVVVQ7O6+pjQZhXJyASBSA18oe2rBhFFMKU+THEQq9CI2262a4e5cRBF5MxS7jAxQ
         gIXLeEoW6hexcSgM59so5b3p0biZ1kzjsbRyoCpD9dbQcrmD6fCwbZ2uNaVVpVAzKVG3
         LBVb7v4MK/63UDXCSTKn/8NTXliky/2YI4DJonl4G/zWBDK5bz9SJpY+m1PJ22uLUkzG
         24VQ==
X-Gm-Message-State: AOAM533x0MLd+rlO8px4k/hA+xokNOq1X60sV3m7whNVDUMhGvruuVHa
        mwJghIgLQ57v+wi9e5fxA6E=
X-Google-Smtp-Source: ABdhPJykggZDIAVAXmRbeYWXuLMu3UvItgKVCCxVjen0/4GBZzuzIGAZmQgjrGUyGZjMwcuf9HP87w==
X-Received: by 2002:aed:239b:: with SMTP id j27mr50809330qtc.183.1594047540521;
        Mon, 06 Jul 2020 07:59:00 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:74c4])
        by smtp.gmail.com with ESMTPSA id c27sm18469834qkl.125.2020.07.06.07.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 07:58:59 -0700 (PDT)
Date:   Mon, 6 Jul 2020 10:58:58 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     akpm@linux-foundation.org, stable@vger.kernel.org, dxu@dxuuu.xyz,
        chris@chrisdown.name, adilger@dilger.ca,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk,
        hughd@google.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] vfs/xattr: mm/shmem: kernfs: release simple xattr
 entry in a right way
Message-ID: <20200706145858.GA5603@mtj.thefacebook.com>
References: <20200704051608.15043-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200704051608.15043-1-cgxu519@mykernel.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 04, 2020 at 01:16:08PM +0800, Chengguang Xu wrote:
> After commit fdc85222d58e ("kernfs: kvmalloc xattr value
> instead of kmalloc"), simple xattr entry is allocated with
> kvmalloc() instead of kmalloc(), so we should release it
> with kvfree() instead of kfree().
> 
> Cc: stable@vger.kernel.org # v5.7
> Cc: Daniel Xu <dxu@dxuuu.xyz>
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Hugh Dickins <hughd@google.com>
> Fixes: fdc85222d58e ("kernfs: kvmalloc xattr value instead of kmalloc")
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
