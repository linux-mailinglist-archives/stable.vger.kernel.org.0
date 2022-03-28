Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302904E918B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239889AbiC1Jk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiC1Jk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:40:26 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E726913D47;
        Mon, 28 Mar 2022 02:38:46 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f10so3968798plr.6;
        Mon, 28 Mar 2022 02:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kSPMoIuWL9FXjN+mAnYdY25Lo8PRjU76MHfmUpfVXVs=;
        b=IMdm7fMd88UVnKMkI1wdPkZmSds+d4Fbesv2Y+svsa/iljkTo4Hi0a6KHzYFxgZMTm
         kib/TKA8jXbtcC/D57pLvWgWyibonGcfANHOR0JLTgFReatfDNer6C3iRIZ9E+w6IwRQ
         O9O6vC7ZF1mIvkzeEmWPlmBhuDG4T0BH0siMhij+0nBrM3SIvGNE5J6zikfaWdzdEpln
         PXneyfQIcBLijbiiNCbrkpuRhmZdLlb+/j1BdnJypfSSwXyjUaCcINgZVb/OgKue87/q
         BPipgM0fjt1GYeuqlrBZ97UG8gxRuf9IC3nEUgIAwiPF5v3W0DVuyqduoxzMEEnKtpZV
         6bxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kSPMoIuWL9FXjN+mAnYdY25Lo8PRjU76MHfmUpfVXVs=;
        b=KWFji7RYNTzoEUEpxrockicQkc8368IOgL557K+oUkbNYfZP6SEHTBeRBXQM3nAgtl
         F1PxX1Qyw+wz6YOJCT7eQ+kYgI6YAFntJ/tlN6TW05EyHHB0PbIk/79ZRvUSMWbJkn5R
         +3fAWB8LZ70MFYpH0HrvqRB1HY9OwI+eqjeuTl3xBkrNmFguJ5VlsZesWSNrnrA2X4cx
         +FlxlR0WHJbZ1id5O6Pzc6ki2/b+3EybonnwCm7OaX/dxEqkK85/ZlVh5T6CnQeAVaHK
         6ST2LOYqVa5M3BcqGQg2jJ3P7nM6mrnbaFU2lsJRn8hh1XuhSto2X1DeXyrB98dS6OVr
         DdoA==
X-Gm-Message-State: AOAM531fe3Chiq+oAPSAyfqFVLMCpJFnbonxWxEhwtTcvef59XaxI0Ty
        AKMbq8flAwMSd9W2+Ibb+eQ=
X-Google-Smtp-Source: ABdhPJwd3Kvd5Gx8C8CWNFbj86fF16CZZwvwxBWlW9+TXd4T/qw23dd8dU5QaNPdwStSu2Yidnsacg==
X-Received: by 2002:a17:902:f54f:b0:154:5686:7616 with SMTP id h15-20020a170902f54f00b0015456867616mr24668500plf.125.1648460326246;
        Mon, 28 Mar 2022 02:38:46 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id y12-20020a17090a784c00b001c6bdafc995sm17230900pjl.3.2022.03.28.02.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 02:38:45 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     svens@linux.ibm.com
Cc:     agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        dsterba@suse.com, elder@linaro.org, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com, jcmvbkbc@gmail.com,
        jirislaby@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH v2] char: tty3270: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 17:38:31 +0800
Message-Id: <20220328093831.28087-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <yt9dczi6cvln.fsf@linux.ibm.com>
References: <yt9dczi6cvln.fsf@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I should have written that in my first reply, but s == NULL means
> the given line number couldn't be found in the list of lines. This is
> a serious error and should be warned about. So maybe something like:
> 
> if (WARN_ON(!s))
> 	return;
> 
> But allocating a new empty line in that case is certainly wrong.

Thank you, i have resend a v3 patch as you suggested.

--
Xiaomeng Tong
