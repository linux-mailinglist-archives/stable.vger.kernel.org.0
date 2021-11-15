Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF23345177F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 23:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhKOW36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 17:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349527AbhKOWTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 17:19:11 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C03C025543
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 13:37:37 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id m11so18217993ilh.5
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 13:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=AcKSBTvLAW0gj40GbXq2aP/U78AStpOkB0MPl9oMU5U=;
        b=v9PY7keA/WOnuwebpkySYYfb3fifjLPflW1uRGH1P1DoaUTZBjG0Fj77dKlFcZBz15
         VFwDd42szs4hKUi1ekn05lhDXx6LUJ4Cg+vLfHz+4p/5cLwocbAXl4HU9j6z9INBDQrV
         n68Dx/GdigRjoOC9V0P+KqOZEjlHkPKG8bMU5Um3gSto+jwrjx119w9gxGn5F4iuPsZL
         yeA+ViWknSnYBuV3RVNrlggI1Heb+6QP0wTmBEP7decqGnbkbU3Xm04jvM/RQ3BX+/ga
         tuAHHUPkulvitg21kNN+HZGty3eZCHgjDUgD1k0sVwIEDgQb+Kv632/Y+nbKO4qu3ZpJ
         H7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=AcKSBTvLAW0gj40GbXq2aP/U78AStpOkB0MPl9oMU5U=;
        b=Lsf4zc0q78nPyn7RtP27DQKgQ9ZuyHIQrYH7IRkSm2/+1C/ZwCZtR/hy59BNgzt6ac
         kQl7yY0x+sz/gsOnJ1qhvjhBRlE5I1utHpNgMC9NtxMubJYCd+C2spvDKNKCX5ue7KDH
         hRnPITs/vWGwjy6rgAsJg7PbIh363HYdh5eviKMvLqYQq5xn05/0WrX/INv+fhI/WuUL
         fbDpUOwfzLQ9ny+Q9KuzclrNpXTchp7BNTyqwpkUR8QMyM+1+tKCpzuSqf8lxFBQrS48
         zaIFCxclG+Hm9vPoZl5Pvhj6KkZDyCHDl9cVYT1Y4yIldA9ovhgxJyliGfuI1jt+zfvV
         ObyQ==
X-Gm-Message-State: AOAM531CH9EXhNLpQbWT/FnU/4ueA3Wq2yh/VAuftXEo4HfSOq59/GHE
        156QhT83FHPrug2mbdt1g/yobA==
X-Google-Smtp-Source: ABdhPJwXrMjYdhOuZhYyB1MaOORmDZWRJav/IZApf9RJkatUYCCTo84c2Ob9wG9NDX4eI7z70eI3VQ==
X-Received: by 2002:a05:6e02:17cc:: with SMTP id z12mr1240203ilu.267.1637012256820;
        Mon, 15 Nov 2021 13:37:36 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b6sm11771900ilv.67.2021.11.15.13.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 13:37:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, Alistair Delva <adelva@google.com>
Cc:     linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, kernel-team@android.com,
        selinux@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>,
        Serge Hallyn <serge@hallyn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211115181655.3608659-1-adelva@google.com>
References: <20211115181655.3608659-1-adelva@google.com>
Subject: Re: [PATCH v2] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Message-Id: <163701225573.78831.14755675586127114548.b4-ty@kernel.dk>
Date:   Mon, 15 Nov 2021 14:37:35 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021 18:16:55 +0000, Alistair Delva wrote:
> Booting to Android userspace on 5.14 or newer triggers the following
> SELinux denial:
> 
> avc: denied { sys_nice } for comm="init" capability=23
>      scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
>      permissive=0
> 
> [...]

Applied, thanks!

[1/1] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
      commit: 94c4b4fd25e6c3763941bdec3ad54f2204afa992

Best regards,
-- 
Jens Axboe


