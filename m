Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594402C2A78
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 15:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389316AbgKXOxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 09:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389315AbgKXOxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 09:53:39 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD328C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 06:53:37 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w16so5316419pga.9
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 06:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=woDq3Idd77JT8bUgO/7z+pbsn29k605P65KY3W0bDLw=;
        b=m+fHAbRXPX3B24JmOeqgROjKJU7sN2nSfF1m7Whk6xqMJmODIEqkjQr8BpUg1LGSr9
         vb2UoOn5abU6oyg6XJ4sCYP4ZlBkv+4oanZYJiwkqBvQcjmvkZ2f+zxZH7AjC6vxtkrC
         JFJgrwAOreM8jm9kUKEBYmaNdh0IOOLsukeALtC9C940XuFN1LP1LcOJxBPOsmHnxQX5
         gYFWlOHT7DhMUFvH5rTWbuTY+I6jf4i885cMsS6g/pYYFVfoysRZJiSE5lygXMlW5YpG
         FtiEZT9yndzfl42PutmKDMi12/ybYlsdQpGZiUXNI/qf5sHEhFKT9Hq+I0CEmfEHje8g
         U2ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=woDq3Idd77JT8bUgO/7z+pbsn29k605P65KY3W0bDLw=;
        b=Xc8az+X2k+j2pVcIGR7W2E696kOR/xQpIxl8IqKDDJbzokTdMcm9js0u9+wcTTCKpB
         13Tn06So678W3BXfNcXKovtQG4xoOoMcKcWrGdW8MxZZXbvAHwwKlrKWtWZw2SG5Sbw9
         4tooqkYeEqeNnKSsXcBTSM4qKSZjC0dgjJSTvVkMkyQnbZdREqr2kJ9JYXTAJDeZKTSa
         YfSz5Daib9fcVDM+ukEgH+2bPImB0GA8lzuFEvE/hp0KtQU/HV2KgW6yqZr7t5wMFX0g
         t42zB+DK01/C1+IwnlbWofEAp10Al1KxoU+dyWY3u+VCHAPOkKWy60MNXitAakb2UOh1
         9e3w==
X-Gm-Message-State: AOAM532uMfk6/UE3XfRJYirRlucD/Mlmn5+0JuqG2OCLBTpbOgI4bO+H
        FTVXxstflsiqo/63s12ST6nlaw==
X-Google-Smtp-Source: ABdhPJz11qnukyjV3uaiIZNHAHkAKJQXYCr7OCY6IwFY8VyZVKEnR6ZQx2+qnStHaLnkpCSaj7AjiA==
X-Received: by 2002:a63:389:: with SMTP id 131mr4080904pgd.128.1606229617169;
        Tue, 24 Nov 2020 06:53:37 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y81sm15808065pfc.25.2020.11.24.06.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 06:53:36 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: fix ITER_BVEC check
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org, David Howells <dhowells@redhat.com>
References: <26e5446cb6252589a7edc4c3bbe4d8a503919bd8.1606172908.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee68dd26-b90e-e2fb-7fb6-28771920aba0@kernel.dk>
Date:   Tue, 24 Nov 2020 07:53:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <26e5446cb6252589a7edc4c3bbe4d8a503919bd8.1606172908.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/20 4:20 PM, Pavel Begunkov wrote:
> iov_iter::type is a bitmask that also keeps direction etc., so it
> shouldn't be directly compared against ITER_*. Use proper helper.

Applied (with fixes added), thanks.

-- 
Jens Axboe

