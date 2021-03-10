Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E626333695
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 08:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhCJHr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 02:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbhCJHrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 02:47:36 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBACC06174A;
        Tue,  9 Mar 2021 23:47:36 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id l2so10850660pgb.1;
        Tue, 09 Mar 2021 23:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=utFuLZK1zPSYLVkQnM9VsZ3uv6ifJQqotmj3ZtAm8fs=;
        b=GkhE+mK9KYnV09Je9GdKGBCeef4kZim6uOf8AFPMHyqHdmXdtodvDqrZ9iYrhLgWeV
         ay9KsAEZXpCWf5MwnWaMUQU79OrVZcX2Au2qkCFpSQNGYw7X1Js4zHH3DRgp8mTV4hdB
         VEMkGwgSEz0VE+pJNY02aje8UT3rhv/Pt/bLIJWw/vDtqM3me0aeeS1O/pNw+iuE5D3t
         N1Z+V1E+/+/9LPdGlRsPXa8scrlGr/36LTDniOEGWClM4tJ4zgka/38F/5cqa3CQGEvx
         eQ+Qt+Udn+Pe2BXk9Nc2SE1Qjrklq6mZRHteI7bpCYzWDSPuMeoqtfN1r44cKslE31xM
         ykfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=utFuLZK1zPSYLVkQnM9VsZ3uv6ifJQqotmj3ZtAm8fs=;
        b=lr+ycrwwEC4wl79Xwde3TN+Mj+Rd5s3/c3P2hOE1B+epVFbRMmI9H74FbroBxNdHP4
         lQhbmGdWBzdDpvUxVe7OeQoA8FAlQdqeGzZTVz11wvLPFOz9Y6kLqq665YHxwibBbmWW
         jn8YXVvctSJ3zGWAFCXV+zTijyQ622cnVT27Cs0xi7rSs2ibSzGXfhkGt9/TwIuZYkRi
         KCWlJ+UQA+6ygg/AxN7Xay/cdGw3lRMKijMn1fmZV1slqv+cCsoYeVBtGLb4rRW9w8V/
         qbb9Ju4DSV05DKmfrbbUQRc5B8eg4+NrNppmT73ED4fkluCD/BwublehqygKmVPkMP0f
         NCgw==
X-Gm-Message-State: AOAM533dSUjCM89BE75ph7+k4wr198Jli9m4o0vAqX20kde++Vr4CZiW
        EQrYw4vW2hKyjO6Nxm5Qoac=
X-Google-Smtp-Source: ABdhPJxQXuUUWkmRB7wGXh7STqooxt3S0orehRuSKcAl/jPbAfwrMKcq3vm63HoVBN/79m6MDFVb8Q==
X-Received: by 2002:a63:d842:: with SMTP id k2mr1694746pgj.428.1615362456288;
        Tue, 09 Mar 2021 23:47:36 -0800 (PST)
Received: from google.com ([2409:10:2e40:5100:30c3:e7ed:8b0a:7f01])
        by smtp.gmail.com with ESMTPSA id k128sm15004701pfd.137.2021.03.09.23.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 23:47:35 -0800 (PST)
Date:   Wed, 10 Mar 2021 16:47:30 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in allocation
Message-ID: <YEh5kk3rGXr5nLRj@google.com>
References: <20210309234317.1021588-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309234317.1021588-1-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (21/03/10 00:43), Ricardo Ribalda wrote:
> 
> The plane_length is an unsigned integer. So, if we have a size of
> 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
