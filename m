Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B756CEF5B
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 18:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjC2Q3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 12:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjC2Q3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 12:29:06 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EEE5FFA
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 09:28:58 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-53d277c1834so302774717b3.10
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 09:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680107338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dt969B268Cmv9eteHkfYLwncO67M/hrSlfvm7bCaKLg=;
        b=swV1ZSPFEmw/g2v+9uotNE+RbyT9SbnZ5/ZjsK6ifQw942O9shN0kYC0llHjw87Kjy
         +tqdAYbmKGZ02ScK8NPyO26NaOggmqL2uM3CfJdlAp43uDKZB8+0WFEIfgqtf/rPatr5
         73/zrAXFsjOpQ4qQKWC2/pgfrsL/PHu3awnsGkABenmpiX+VIz+Y/ISLyVfG6vubBDDh
         Tdohld04v3PgJI9NudBBKeroVvsIpCp45LGM1jVHrfCtq36r+vhkp4pux69tGQk+G9dA
         /0e6o4cSab8559nbhXAks4PdQlbfQuljWlRVwqcZ8/Sv/N6ppt0v9ucUq3PjIdfy+F3u
         oIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680107338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dt969B268Cmv9eteHkfYLwncO67M/hrSlfvm7bCaKLg=;
        b=QhwDiw3/PWpu0bKx+rNk0KoY7ck4WqgTENQYA142njOhaGOUTZSvL0UWMwX3wsRok/
         7al5iVhZ36MIHqCI52mh3PJMG2ghVmLccARkEtPoqzBA3mGVDE1lobP3BEqf5VYwb1fY
         flYtSOGpxf8ql2V9vccG9LKsAvDmFwyFn9KvwDDpm73Yd0Cl2eLq27uLRHb/Knu5s+23
         5JXQZEsnEMO0YtMmtvwykDwLKUoGVqtM9jAHeScpbwnG+UL4s0Mfag+YY+Y/bhWwUiaL
         WBrjVJf2d1In7Byz9Vlexw1mm8Q+4znA5zmopFKYm8S0+YZkNMRXdtPWF/wz4llywK9S
         zJVg==
X-Gm-Message-State: AAQBX9dvkrJVAxvgD+oqrPFTvUliZBtg2/OYHWXDEoTdcIJh/ImPHqhO
        PqeuaNPWJGYf4hpthjtsp+1ym6lyDFYcM5jwbhaWMdCR1AAPScDYVmYi7w==
X-Google-Smtp-Source: AKy350ZcNhgBZnWaNwHOxxDEq+95tVkApFNvCBt7ntU0f6EkCktQ3qLj6Aub6DvWmr/WH1iiHu28GCmyL9zK0yr8my8=
X-Received: by 2002:a81:c84a:0:b0:541:753d:32f9 with SMTP id
 k10-20020a81c84a000000b00541753d32f9mr9703314ywl.9.1680107337982; Wed, 29 Mar
 2023 09:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230327220432.4165615-1-nobelbarakat@google.com>
In-Reply-To: <20230327220432.4165615-1-nobelbarakat@google.com>
From:   Nobel Barakat <nobelbarakat@google.com>
Date:   Wed, 29 Mar 2023 09:28:46 -0700
Message-ID: <CANZXNgM-DOcE4FSofObm-LgDBAeykTTPwOALcWjvrg6iD61eNA@mail.gmail.com>
Subject: Re: [PATCH 5.15] act_mirred: use the backlog for nested calls to
 mirred ingress
To:     stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        William Zhao <wizhao@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

Sorry, looks like there's a backport already in stable-queue. Pleas ignore =
this.

On Mon, Mar 27, 2023 at 3:04=E2=80=AFPM Nobel Barakat <nobelbarakat@google.=
com> wrote:
>
> From: Davide Caratti <dcaratti@redhat.com>
>
> commit ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640 upstream
>
> William reports kernel soft-lockups on some OVS topologies when TC mirred
> egress->ingress action is hit by local TCP traffic [1].
> The same can also be reproduced with SCTP (thanks Xin for verifying), whe=
n
> client and server reach themselves through mirred egress to ingress, and
> one of the two peers sends a "heartbeat" packet (from within a timer).
>
> Enqueueing to backlog proved to fix this soft lockup; however, as Cong
> noticed [2], we should preserve - when possible - the current mirred
> behavior that counts as "overlimits" any eventual packet drop subsequent =
to
> the mirred forwarding action [3]. A compromise solution might use the
> backlog only when tcf_mirred_act() has a nest level greater than one:
> change tcf_mirred_forward() accordingly.
>
> Also, add a kselftest that can reproduce the lockup and verifies TC mirre=
d
> ability to account for further packet drops after TC mirred egress->ingre=
ss
> (when the nest level is 1).
>
>  [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae=
226.1663945716.git.dcaratti@redhat.com/
>  [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain=
/
>  [3] such behavior is not guaranteed: for example, if RPS or skb RX
>      timestamping is enabled on the mirred target device, the kernel
>      can defer receiving the skb and return NET_RX_SUCCESS inside
>      tcf_mirred_forward().
>
> Reported-by: William Zhao <wizhao@redhat.com>
> CC: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
> ---
>  net/sched/act_mirred.c                        |  7 ++
>  .../selftests/net/forwarding/tc_actions.sh    | 92 ++++++++++++++++++-
>  2 files changed, 98 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index d64b0eeccbe4..120fd3ef8827 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -203,12 +203,19 @@ static int tcf_mirred_init(struct net *net, struct =
nlattr *nla,
>         return err;
>  }
>
> +static bool is_mirred_nested(void)
> +{
> +       return unlikely(__this_cpu_read(mirred_nest_level) > 1);
> +}
> +
>  static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
>  {
>         int err;
>
>         if (!want_ingress)
>                 err =3D tcf_dev_queue_xmit(skb, dev_queue_xmit);
> +       else if (is_mirred_nested())
> +               err =3D netif_rx(skb);
>         else
>                 err =3D netif_receive_skb(skb);
>
> diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools=
/testing/selftests/net/forwarding/tc_actions.sh
> index d9eca227136b..f9070b3bdba2 100755
> --- a/tools/testing/selftests/net/forwarding/tc_actions.sh
> +++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
> @@ -3,7 +3,8 @@
>
>  ALL_TESTS=3D"gact_drop_and_ok_test mirred_egress_redirect_test \
>         mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
> -       gact_trap_test"
> +       gact_trap_test mirred_egress_to_ingress_test \
> +       mirred_egress_to_ingress_tcp_test"
>  NUM_NETIFS=3D4
>  source tc_common.sh
>  source lib.sh
> @@ -153,6 +154,95 @@ gact_trap_test()
>         log_test "trap ($tcflags)"
>  }
>
> +mirred_egress_to_ingress_test()
> +{
> +       RET=3D0
> +
> +       tc filter add dev $h1 protocol ip pref 100 handle 100 egress flow=
er \
> +               ip_proto icmp src_ip 192.0.2.1 dst_ip 192.0.2.2 type 8 ac=
tion \
> +                       ct commit nat src addr 192.0.2.2 pipe \
> +                       ct clear pipe \
> +                       ct commit nat dst addr 192.0.2.1 pipe \
> +                       mirred ingress redirect dev $h1
> +
> +       tc filter add dev $swp1 protocol ip pref 11 handle 111 ingress fl=
ower \
> +               ip_proto icmp src_ip 192.0.2.1 dst_ip 192.0.2.2 type 8 ac=
tion drop
> +       tc filter add dev $swp1 protocol ip pref 12 handle 112 ingress fl=
ower \
> +               ip_proto icmp src_ip 192.0.2.1 dst_ip 192.0.2.2 type 0 ac=
tion pass
> +
> +       $MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 =
\
> +               -t icmp "ping,id=3D42,seq=3D10" -q
> +
> +       tc_check_packets "dev $h1 egress" 100 1
> +       check_err $? "didn't mirror first packet"
> +
> +       tc_check_packets "dev $swp1 ingress" 111 1
> +       check_fail $? "didn't redirect first packet"
> +       tc_check_packets "dev $swp1 ingress" 112 1
> +       check_err $? "didn't receive reply to first packet"
> +
> +       ping 192.0.2.2 -I$h1 -c1 -w1 -q 1>/dev/null 2>&1
> +
> +       tc_check_packets "dev $h1 egress" 100 2
> +       check_err $? "didn't mirror second packet"
> +       tc_check_packets "dev $swp1 ingress" 111 1
> +       check_fail $? "didn't redirect second packet"
> +       tc_check_packets "dev $swp1 ingress" 112 2
> +       check_err $? "didn't receive reply to second packet"
> +
> +       tc filter del dev $h1 egress protocol ip pref 100 handle 100 flow=
er
> +       tc filter del dev $swp1 ingress protocol ip pref 11 handle 111 fl=
ower
> +       tc filter del dev $swp1 ingress protocol ip pref 12 handle 112 fl=
ower
> +
> +       log_test "mirred_egress_to_ingress ($tcflags)"
> +}
> +
> +mirred_egress_to_ingress_tcp_test()
> +{
> +       local tmpfile=3D$(mktemp) tmpfile1=3D$(mktemp)
> +
> +       RET=3D0
> +       dd conv=3Dsparse status=3Dnone if=3D/dev/zero bs=3D1M count=3D2 o=
f=3D$tmpfile
> +       tc filter add dev $h1 protocol ip pref 100 handle 100 egress flow=
er \
> +               $tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
> +                       action ct commit nat src addr 192.0.2.2 pipe \
> +                       action ct clear pipe \
> +                       action ct commit nat dst addr 192.0.2.1 pipe \
> +                       action ct clear pipe \
> +                       action skbedit ptype host pipe \
> +                       action mirred ingress redirect dev $h1
> +       tc filter add dev $h1 protocol ip pref 101 handle 101 egress flow=
er \
> +               $tcflags ip_proto icmp \
> +                       action mirred ingress redirect dev $h1
> +       tc filter add dev $h1 protocol ip pref 102 handle 102 ingress flo=
wer \
> +               ip_proto icmp \
> +                       action drop
> +
> +       ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
> +       local rpid=3D$!
> +       ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
> +       wait -n $rpid
> +       cmp -s $tmpfile $tmpfile1
> +       check_err $? "server output check failed"
> +
> +       $MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1=
 \
> +               -t icmp "ping,id=3D42,seq=3D5" -q
> +       tc_check_packets "dev $h1 egress" 101 10
> +       check_err $? "didn't mirred redirect ICMP"
> +       tc_check_packets "dev $h1 ingress" 102 10
> +       check_err $? "didn't drop mirred ICMP"
> +       local overlimits=3D$(tc_rule_stats_get ${h1} 101 egress .overlimi=
ts)
> +       test ${overlimits} =3D 10
> +       check_err $? "wrong overlimits, expected 10 got ${overlimits}"
> +
> +       tc filter del dev $h1 egress protocol ip pref 100 handle 100 flow=
er
> +       tc filter del dev $h1 egress protocol ip pref 101 handle 101 flow=
er
> +       tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flo=
wer
> +
> +       rm -f $tmpfile $tmpfile1
> +       log_test "mirred_egress_to_ingress_tcp ($tcflags)"
> +}
> +
>  setup_prepare()
>  {
>         h1=3D${NETIFS[p1]}
> --
> 2.40.0.348.gf938b09366-goog
