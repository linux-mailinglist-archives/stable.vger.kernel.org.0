Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856E8621E15
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 21:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKHUzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 15:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKHUzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 15:55:02 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54F458014
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:55:01 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id o13so5115094pgu.7
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 12:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qRhZihzutt4EuEV5aJb6zGoJq6kW+KLDgBNfKrJXVe0=;
        b=Ne6UrDY2D5endYOy1ov++Y0PSlA/kr/NMX1X8EDT8f+URY338crgjazWkXUACPiceb
         u0NbV9Y0uAMXLVGuhXF735ARL2cneLLKcHxDVitRSkvheYq8ujZRqM8lXVIdUsy83kcg
         oWLMHNOCr0FJVeYGLvjywg2v2nx20pkMsWpjYPSrIy4sI/RtFtxU3kFnc+RSthBmLJHv
         exFV9LYIF9F3T8Raszs5u57yEwj+kspC/7avnIaOBXezZh28XG85atQpjqiADwZSNhrf
         rHhqVo5Mc+2Jcx2HgmmILWCQ5dQPZfNafV//cgky1lZ//BcRUlWgNvH3WPFV6N1hN/2K
         VVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qRhZihzutt4EuEV5aJb6zGoJq6kW+KLDgBNfKrJXVe0=;
        b=tD8aeFkUAKsxYArWkCD8sVRuTr623nuUCKKbfTS9+difvez5mMKGrsyCGhX9UxF2Cq
         rYMmTzwO55OH3QWFKwJFfeLOv8J490MraRg6MpbtkmqX0Jffmef2aACJjkK/BPdrprU0
         /Ati0UqYE2+cM5RQ+FbxEqLrXzJ/f0yRPlrHAjrpR3NBxUhJ0YjbS5vOGNSqYSIPfB7m
         KGfAlBLeDAkdAvvGZfHlOH9u/eFqeC9psnlvxtxxNjcJrSo3L2cTuJ/fpLV3VmI2dpDP
         RldrjZN3HU4ZX8lT12Xf7w2ezytJCDOAp/SPe/oRbIsfDJTEnFRB+c68yvjbzvLRVvbm
         q99A==
X-Gm-Message-State: ACrzQf0uv0SX+NKr0X4YLZJes9ua4DLvCaQB9K/hz3WIFym6aL6o62Sm
        pzI3+dDNVg6Rh59GE3JlAc3zaw==
X-Google-Smtp-Source: AMsMyM4hQIovhp0PPXN/nbGakTK+GK4xLhkQ2uly/XTZcMvP5morl9Xe15iYtGqQ5Qcf+iLe6lJJ6g==
X-Received: by 2002:a05:6a00:1a04:b0:52a:d4dc:5653 with SMTP id g4-20020a056a001a0400b0052ad4dc5653mr57981220pfv.69.1667940901160;
        Tue, 08 Nov 2022 12:55:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i126-20020a626d84000000b0056c0b98617esm6816064pfc.0.2022.11.08.12.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 12:55:00 -0800 (PST)
Date:   Tue, 8 Nov 2022 20:54:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/8] KVM: SVM: replace regs argument of __svm_vcpu_run
 with vcpu_svm
Message-ID: <Y2rCIWtAsmEF1UuM@google.com>
References: <20221108151532.1377783-1-pbonzini@redhat.com>
 <20221108151532.1377783-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108151532.1377783-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022, Paolo Bonzini wrote:
> Since registers are reachable through vcpu_svm, and we will
> need to access more fields of that struct, pass it instead
> of the regs[] array.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")

I don't think a Fixes: tag for a pure nop patch is fair to the original commit.
