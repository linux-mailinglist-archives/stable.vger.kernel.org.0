Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC543C552
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbhJ0Ik3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239187AbhJ0Ik2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 04:40:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C95C061745
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 01:38:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g7so1661732wrb.2
        for <stable@vger.kernel.org>; Wed, 27 Oct 2021 01:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4UAfLG95f2ntu5NMsJJZGVxq5Ea4XqyDufFWTyZc3Rk=;
        b=fddbrWlWx0Fby+9qGR8uvz1YCtY10pv6dVWFA+emfTEA/2FBinO83s6uVfLQ4Uupbc
         OMOVx+9HMJEG+2pygjbOcC70Ejrne63PVfdufXULjrfYkPLyom0iq55a0rUjO0wvL/vF
         Ar43Ll5MlJthmBwmkGemoVGfx6W9I6MUJcvGF0BUob9ykM26DvCjBBkxeL72SSPRku0q
         O8e4xUmoz0GKKelo2pcE+abDMcWtEfDM5QzMOcCPnG6haeu+kO2xZsQGEq4VLbfKjzo2
         XOa4v+a20J/SeTbQmXaAkEQpwWoepCWeKzJa8IYDB25yNNHKEAUoisyVbBbIgBmEMrri
         egIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4UAfLG95f2ntu5NMsJJZGVxq5Ea4XqyDufFWTyZc3Rk=;
        b=INtHR3nn4wi7zGatvER5N+so94Nq/CI+RJ9PWYZCze0OTrcvGRD1/v4bh+WHC97SER
         95KuF2S6GoiJQkpE4N3Q4y6lawEIOx2bBqYEkI7roiP1VR7hhXthunZrP1ZZ/EmsKyKi
         Y63wICQYMZogAy+RXjqAq/hf9K6AeQCoqW+MPDZzBsxspSLuJ+H3USopEZ1jCmNJocrq
         uHmN8taWsG4pDSk4NWN0jEbWh9Il6HCU/m0LUf8OOB1G3S1z7EOhaUILenuuPGPeHXT3
         GqiaY9C1HXCyOmyfJjpQX7U4Y/297o/NrWOyY5vb+s/7I4/U+adBGL3dB1KvMZFHs/Bz
         VNyw==
X-Gm-Message-State: AOAM532qn9o9Gt+QefRgELVNP4Iz538OMaTQ/jBSlapDsOfTXbS0R7Ce
        aIQapySpi6Cbqpnv1+k0SixF30lLdZvfAA==
X-Google-Smtp-Source: ABdhPJwMMHyW5kZdqvlRF0nvAIHV0pjT/6da6OLVMP+QP/ewCeK4dz8U/xM2+1EUTrjrkvrkGJbpyg==
X-Received: by 2002:a05:6000:2c2:: with SMTP id o2mr39285055wry.194.1635323881808;
        Wed, 27 Oct 2021 01:38:01 -0700 (PDT)
Received: from google.com ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id d24sm2655421wmb.35.2021.10.27.01.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 01:38:01 -0700 (PDT)
Date:   Wed, 27 Oct 2021 09:37:59 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXkP533F8Dj+HAxY@google.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
 <YXkLVoAfCVNNPDSZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YXkLVoAfCVNNPDSZ@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021, Greg KH wrote:

> On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> > 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> > inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> > hunk of commit which does so.
> 
> Why can't we take all of that commit?  Why only part of it?

I don't know.

Why didn't the Stable team take it further than v5.11.y?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
