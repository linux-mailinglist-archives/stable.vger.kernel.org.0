Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEB1333691
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 08:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhCJHqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 02:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhCJHq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 02:46:28 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49120C061760
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 23:46:28 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id ga23-20020a17090b0397b02900c0b81bbcd4so6765026pjb.0
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YtSOPZCf9Da269ZEPcGrsyfquqgeGyegkCV8/Htilvk=;
        b=R5gEY8VaX1kw0BYeYWpOh2pvYK1+99hrZLVbBXAd3RwBgFjYc1B57PG7nhkaYE0mLc
         SXm6a1/sZRJ3lPzuMVqkrY91FHDPAe9Jscu5lh0y5zZmfoNOf7VeB8S4X77/Gr9e1ujv
         wuL7xpQ/EtRPPpp/f3fxRXxIVUJhTNkZFIIqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YtSOPZCf9Da269ZEPcGrsyfquqgeGyegkCV8/Htilvk=;
        b=Ur3SRqjR0WmoZWqceDwgCkSIctMrgjvytk+qwoQNv6mtKE7JAlbdJxh8MLqJa5FmpE
         ZfXXZKISooh/FrAXOUumudGD5tDJs+GOIhPfVZ2hcAumGnADiL2Dy0Z1cOI+Oyhx5jbV
         qaliRvK7X2h+PaRWFR1TU1vQLt8L9k/I7bfM0uJmEnE/N4R9Xy4Jzz4+PPt5xu5q2ioQ
         XGrH+BT6ea+yl2bx4iuAX6HU6En8xFw4E/LJdvPFsrWjIprE0l24nCUu8B4xGmCQI7iP
         NlUz9e7pWOsARSm8NEWitAEQ/MDp/W/ovszoiQi7G/SXnc+/ZHbV/mVrqjXIECRBimWm
         4YRA==
X-Gm-Message-State: AOAM531m8nwRpsgO/IG2cmOFDSDYs5x8AwR7ov533dTBPb2xMLWTQtrk
        r7pGfnTocqWqpmJXvGfgNEB2zvHwoYyIBg==
X-Google-Smtp-Source: ABdhPJwEa8CkSLK2/AJuxaIcUqDxCJOy2d+vmOQXrdTz9u3hdWTy0ok3NvdeQBqSoRxViggpDTF0wQ==
X-Received: by 2002:a17:90a:8:: with SMTP id 8mr2313414pja.6.1615362387840;
        Tue, 09 Mar 2021 23:46:27 -0800 (PST)
Received: from google.com ([2409:10:2e40:5100:30c3:e7ed:8b0a:7f01])
        by smtp.gmail.com with ESMTPSA id n9sm1793181pjq.38.2021.03.09.23.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 23:46:27 -0800 (PST)
Date:   Wed, 10 Mar 2021 16:46:22 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in vb2_mmap
Message-ID: <YEh5TmP/fbHeZc2G@google.com>
References: <20210310074028.1042475-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310074028.1042475-1-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (21/03/10 08:40), Ricardo Ribalda wrote:
> 
> The plane_length is an unsigned integer. So, if we have a size of
> 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> 
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>


FWIF,
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
