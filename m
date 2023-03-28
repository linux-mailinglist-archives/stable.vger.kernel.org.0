Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD5D6CCC16
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 23:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjC1V01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 17:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjC1V01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 17:26:27 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149CB128
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:26:26 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id cf7so16948950ybb.5
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680038785;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f45Gb2ROgtR+m92JZBoGbjMMx1cPmlwLai/gDOUxMLU=;
        b=st86l6THZDpS2CL4vUVRajORiIiMLnFmcNnEoyjryq9xEiO2kP6Q26wYLcL+VA7a4W
         0/imTLHtKtTrNpukIE+A8z1aEIlEUXEp5+ox7J6C3Q6lTbYFgSNPaWmoEVlbj1jEQMI4
         mvJ4aWltEVtQlmfwlmtiXfSMX68sSdGN2MJnVUK8ktzJ9YiT221+/GP4S9PnryaRjnWO
         R6tBmUqMn88x21P3hwT8p4t5WtNvSyVB7rDZWrk3+AQYNk33oaUOATs+gEGo+T23Qpa2
         8ebyt6VTvAo1k/FVtLdTMEWWxrUxOLkwaufzYRo854qsAI+V3k7QgBNBbhtyPaYQ7RnD
         Ac3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680038785;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f45Gb2ROgtR+m92JZBoGbjMMx1cPmlwLai/gDOUxMLU=;
        b=Ov8Tcm8Hqj7A24XtoFeCYaVDRBSKlhj2Wco1l+Sgq3Ki/mXheeHXFhN6JBkXMvPfVy
         u245oqjZOCKxWmhcAD9teuzaWHx+XKUrqCL1R/0ZePepQQ3eJlB80kfaBgh+1Bl0d3aD
         fZFJsbvr9jNH3qFcizOj40I38AuuPDlHW5Qi2khfftJMfZpwwzMrIeadF3LlVRumm12R
         400VkGF0efer5x25B4AAnsgB5iE3TJ0LhVnlZUXVIJ7vMtGJRB9o8oWyVCNRTzzIEfWR
         cROC39+Zge3vWyDsKMZNU0XBCrkdk8mlsgIDAHz8i/EHBzRLEn7gDYpWwhgLG9/mF4Tc
         5ZMw==
X-Gm-Message-State: AAQBX9dTGDzBUbm9gwvEDI8sb30rJ6/ip0y1MQNmul93qHue+Y3qDYPH
        /K+ew3tadIHGSDZBxau1fL8tNeIsod6rtQE7NDj97D+IbFklFnmFzv9Y+tVa
X-Google-Smtp-Source: AKy350behfopb8Lbj5JtvvtO+xVa8tOOIav6IX2YSGGjyO1C1KIK9gWyQ67zuMofTCkjg8vR0FtKsxJDDKF/haTsymg=
X-Received: by 2002:a05:6902:168d:b0:b6c:2d28:b3e7 with SMTP id
 bx13-20020a056902168d00b00b6c2d28b3e7mr10653288ybb.9.1680038785056; Tue, 28
 Mar 2023 14:26:25 -0700 (PDT)
MIME-Version: 1.0
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Tue, 28 Mar 2023 14:26:14 -0700
Message-ID: <CANZXNgMFifsEAUjCOtQWwxbZRbSvEYZz_Bwc4zrU6esb3xYRLA@mail.gmail.com>
Subject: 5.10 Backport Request: ovl: fail on invalid uid/gid mapping at copy up
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SUBJECT: ovl: fail on invalid uid/gid mapping at copy up
COMMIT: 4f11ada10d0ad3fd53e2bd67806351de63a4f9c3

Reason for request:
This resolves CVE-2023-0386

CVE context: https://nvd.nist.gov/vuln/detail/CVE-2023-0386
