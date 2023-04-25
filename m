Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6406EE6D8
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 19:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbjDYRfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 13:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbjDYRfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 13:35:03 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418F4CC27
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:35:02 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-44036a3598fso2026979e0c.1
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 10:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682444101; x=1685036101;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qhbVjr7nH6drdXZXqXWAuKXwTmZaOrNrsG0HmrgLkSQ=;
        b=kBDQWEqkSN1adsMyvUvUnab4l7//E2Js+lc6B8vqGCqwF872Fx44TJy1rzRQ3wIyIc
         nvV6jv0+JBNayoYSiItrCwm1h7JjfmjPDycKbhmxD0vjXDTWv/H+lI8oVeDqavVEQdiV
         jMfIR1y5rlY1HsoRv9L7ZBwVIqwlp19ckhQlU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682444101; x=1685036101;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qhbVjr7nH6drdXZXqXWAuKXwTmZaOrNrsG0HmrgLkSQ=;
        b=lBUO9eV3YDYSasSA1wtb9lhPXaJXxax25MRCtrd38nxFH+mEzbeyY+pg2HSTjaoozx
         zoFuf0rjciFUK839Q7JH7BuU6ag59Z67TDJi6RML/W5r6Si+JoZdGWvpXMrX1N0Ddk/B
         756KPX4KCjCOyUz7Ja6EN/5OXlJ9c2vJMqCGVANcku4EO87MwPjA7imcfymv9+emQwgd
         8S3WTUYB94QPbuWy3OXLylRWPaZOSiupAhxcO1OZUefsGMcSNvMnke7dc6UUy4w07co7
         XKmDMyb6UVN4J7Dx2H8fOLZvaiko3KX1oC/DL6mtj4xKCn080mdq9tLAkCXb+WmKn927
         6+/Q==
X-Gm-Message-State: AAQBX9eSvK5ulTp+hD+wCfwrR3G/6bQvajxr8F7OFLuAOACiHIIjVMLt
        dWNnAqdh77phUlJ4dYvNXYL20JevaGHv8rOmXtxttQ==
X-Google-Smtp-Source: AKy350Zg/LVvq+BPYsrIX10DuwFe1FQHCREwo/kFFr6CMS8y2Tf2BhghjlB4p2hPiQRPuOBU7TIjPIcq0R+rBWNESKs=
X-Received: by 2002:a1f:6302:0:b0:43f:eb79:8d62 with SMTP id
 x2-20020a1f6302000000b0043feb798d62mr4401084vkb.5.1682444101384; Tue, 25 Apr
 2023 10:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <2023042354-enjoyment-promoter-9d54@gregkh> <20230424183536.808003-1-markhas@chromium.org>
 <ZEdgSbX3AsaTNBLr@kroah.com>
In-Reply-To: <ZEdgSbX3AsaTNBLr@kroah.com>
From:   Mark Hasemeyer <markhas@chromium.org>
Date:   Tue, 25 Apr 2023 11:34:50 -0600
Message-ID: <CANg-bXCLx2Lb5JN7md1_2XwAR-ijqKOmzMaoiRThtJ9OKtCXoA@mail.gmail.com>
Subject: Re: [PATCH] PCI:ASPM: Remove pcie_aspm_pm_state_change()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     bhelgaas@google.com, kai.heng.feng@canonical.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> What is the git commit id of this change in Linus's tree?
08d0cc5f34265d1a1e3031f319f594bd1970976c

> And can you send it as a stand-alone patch, not one that I have to
> hand-edit out of an email to use?  Doing that does not scale at the rate
> of change we currently deal with at all.
Understood. I'll send a stand-alone patch.
