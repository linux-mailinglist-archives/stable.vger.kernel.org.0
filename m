Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1006785AE
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 20:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjAWTCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 14:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjAWTCA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 14:02:00 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAC51BF3
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 11:01:59 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id t16so11458624ybk.2
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 11:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CKL9+JECp/SVRnsj2folRL4HzaoFVopkLmsGLxbCt1o=;
        b=rvy5TqAa3tS5L/KAqOvOSLYCMrxMzkQY5eMmdZtErr44IDiZUwywzvNwo+zkZMt4gB
         DDZ2x8vGKU5T3HbFGdRC6Z7SRjBepe3j6RskUGAEUxrLB0fiWkiq+JFPgoqf7Hd72ECc
         uVn/gzwKCQtOIV9o5kfYeczNlViG8o1s0xa04auUk9wm3ihK5owapNRGNTdE7JN2SO6U
         wp/Yl+OtcOuzgnz0+dMk1UGFdd3TqHpWeIKmvqknew2CXEhzwyfXGc1aMpfb/Wkfqraj
         ZYMi5s4EBewTD9o/UV2nUQsT6bVnQ9rLIXmRNsRXbUOcPN4718HCko/oGtBMSzz/6pxr
         ul9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CKL9+JECp/SVRnsj2folRL4HzaoFVopkLmsGLxbCt1o=;
        b=uoEJa/Ct029LNRF8ikHzRn8wK9rdK5RGm9F135Ynkn0vRjnoevpDj/EU5k4AABDXWr
         O5x3wlfqjFwU+yeJXfaXpFaTaf8yWhqcufbv/0LSMM8Mdp7aU9v5b9sFI2Kr6WbTHFn1
         pK3yZqBzj+QUzeG0fCE1aqsfIH6p0qDzbJoFaX9L8QZlui7os0i5HXfZvf/5X1ksJKEe
         gSyLKiijcUg4pe/RxNVeZaHTiEl9xHsYEB/Mu1JpZOFpRQrbj/SU+rZSVPs8pWTm6Jvr
         6m2aBRG1tsRkun6xw+64uvY8rXhMKkJaq+0wHrLknRkmStXE39aAOFWmDrV3awhYZYgd
         pKOw==
X-Gm-Message-State: AFqh2kqA6YpXR5/SHTVUfictZNRXGa2fLSVuXEgA3BqSbtfnoqHeC8Wk
        hPbSvNc0f6vQ4X3FPsdOh8fBiIGcvdM2xh5A/sGochOT0UFJ84l6qw8=
X-Google-Smtp-Source: AMrXdXsqaGbpZyGWtbI9GaL5rlPdqolgr+ef1V9P4gWk6l500MyalnOqJd0PQZ71rktrMQLU8aDemQW/l3P/4TQfnRY=
X-Received: by 2002:a5b:d0c:0:b0:7b8:ea18:a17b with SMTP id
 y12-20020a5b0d0c000000b007b8ea18a17bmr1959220ybp.608.1674500518440; Mon, 23
 Jan 2023 11:01:58 -0800 (PST)
MIME-Version: 1.0
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Mon, 23 Jan 2023 11:01:47 -0800
Message-ID: <CANZXNgMiuk=YwZCFO_u-L+20qKZT2xCGWfO7onou4XT+xQNUsA@mail.gmail.com>
Subject: 5.10 and 5.4 Backport Request: netfilter: conntrack: do not renew
 entry stuck in tcp SYN_SENT state
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PATCH_SUBJECT: netfilter: conntrack: do not renew entry stuck in tcp
SYN_SENT state
PATCH_COMMIT:  e15d4cdf27cb0c1e977270270b2cea12e0955edd

Reason for backport request:

We've had a few customers experience issues with dnat such that their
kubernetes processes are now unreachable. Because dnat rules fail to
update, kubernetes pod IPs won't resolve and traffic gets blackholed
causing any healthcheck service to kill and restart the pod. This
commit has been verified to fix the issue and the ask here is to
backport it to kernel versions v5.4 and v5.10.

Thanks
Nobel
