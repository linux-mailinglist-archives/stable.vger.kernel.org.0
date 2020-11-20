Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7C52BAF93
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgKTQDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730017AbgKTQDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:03:25 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4C8C0613CF;
        Fri, 20 Nov 2020 08:03:25 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so8278696pfu.1;
        Fri, 20 Nov 2020 08:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bj0gchYAEfT0+Zss9Gzer9LAxrhaB1wq8M6niTXF50w=;
        b=JDTeI2Nzm7KfLc714MsoPH/dE15KZ3FbOP5cQsl8FFwmzEqNa937LZgF3UoowN6J7i
         9VzrS83m8oP+BOw47FNJ9lgAzuQ3bHkNTapn7fA85dx03sdrMOp6Vpv5cM8+8Yx0wF8B
         AsNO7TO94mz/3BW9ZeOpRsmy8XBiJnFhPQeC1RKwG6koTFCk9V/g90DNMmbVTyh7ELuV
         0v7W0RK5uB6OJEBkkmDUw3Grit9njUDLWk6kBmqkmtO1ekv2ln9caEv04HiIbX0Ffz/R
         /soMYjFL0rG3JfC5Wh5JmGWBCr7kkXPJyFPaJUdsU3xLR6zsoIepOV9fof5g6FjQpSfz
         oFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bj0gchYAEfT0+Zss9Gzer9LAxrhaB1wq8M6niTXF50w=;
        b=lbnYSKsSE2TYOHHT6BWxmfqmQrs0QNSuT/ttdAsvGMjaQBw5MOc5R3iqnUGZbiQqX4
         C6OQ2vF60SjMsj1WKkcxlaKzRJq0A91ddJDc3GTW0BWsYY0H2MhwGICLAeNmK+zxFixd
         G59MfgHPVtKx6PeUcTRv51VDcGoHJkacjcgcsq9UJZ3aT07JYZzHtIzO831lawO5P3ii
         9XjwiV1S8QqDkh/OMH9wgPhfbx5khGopW2r1M5V8ZgL15w814OmLRI64Z0qAo7I45kEi
         1kdSbhQ7mUeo2LeL+n31rTXgWCWhZny5KxQRJkLcsjYnV2qmUos47srBGqvJHBhKEhS4
         W2pw==
X-Gm-Message-State: AOAM5337S9iGd4sb50hJMBoA6Pxil/7IlhjbOR+gPy/O7kE0GD3txofT
        ZYVFWy3+3b+wc39Utqqy4//w+gAQLAM=
X-Google-Smtp-Source: ABdhPJwFQONlyOMa1MFBt6YuwAcdMecVtaTisxvOp3hpZ2oZPZmdZOHYKkKxTV5jxJbHuP9YV0EmMQ==
X-Received: by 2002:a17:90a:a090:: with SMTP id r16mr11067016pjp.179.1605888204706;
        Fri, 20 Nov 2020 08:03:24 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id q12sm4717890pjl.41.2020.11.20.08.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:03:23 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 20 Nov 2020 08:03:21 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Will Deacon <will@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Yu Zhao <yuzhao@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] arm64: pgtable: Fix pte_accessible()
Message-ID: <20201120160321.GB3377168@google.com>
References: <20201120143557.6715-1-will@kernel.org>
 <20201120143557.6715-2-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120143557.6715-2-will@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 02:35:52PM +0000, Will Deacon wrote:
> pte_accessible() is used by ptep_clear_flush() to figure out whether TLB
> invalidation is necessary when unmapping pages for reclaim. Although our
> implementation is correct according to the architecture, returning true
> only for valid, young ptes in the absence of racing page-table
> modifications, this is in fact flawed due to lazy invalidation of old
> ptes in ptep_clear_flush_young() where we elide the expensive DSB
> instruction for completing the TLB invalidation.
> 
> Rather than penalise the aging path, adjust pte_accessible() to return
> true for any valid pte, even if the access flag is cleared.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 76c714be0e5e ("arm64: pgtable: implement pte_accessible()")
> Reported-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
